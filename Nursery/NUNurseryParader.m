//
//  NUNurseryParader.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#include <stdlib.h>
#import <Foundation/NSException.h>
#import "NUNurseryParader.h"
#import "NUTypes.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUPages.h"
#import "NUObjectTable.h"
#import "NUReversedObjectTable.h"
#import "NUSpaces.h"
#import "NURegion.h"
#import "NUOpaqueBPlusTreeNode.h"
#import "NUMainBranchAliaser.h"
#import "NUBellBall.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUPage.h"
#import "NULocationTree.h"
#import "NULengthTree.h"

const NUUInt64 NUParaderNextLocationOffset = 69;

NSString *NUParaderInvalidNodeLocationException = @"NUParaderInvalidNodeLocationException";

@implementation NUNurseryParader

+ (id)paraderWithGarden:(NUGarden *)aGarden
{
    return [[[self alloc] initWithGarden:aGarden] autorelease];
}

- (id)initWithGarden:(NUGarden *)aGarden
{
    if (self = [super initWithGarden:aGarden])
    {
        garden = [aGarden retain];
    }
    
    return self;
}

- (void)dealloc
{
    [garden release];
    
    [super dealloc];
}

- (NUMainBranchNursery *)nursery
{
    return (NUMainBranchNursery *)[[self garden] nursery];
}

- (NUUInt64)grade
{
    return grade;
}

- (void)save
{
    [[[self nursery] pages] writeUInt64:nextLocation at:NUParaderNextLocationOffset];
}

- (void)load
{
    nextLocation = [[[self nursery] pages] readUInt64At:NUParaderNextLocationOffset];
}

- (void)process
{
    grade = [[self nursery] gradeForParader];
    if (grade == NUNilGrade)
    {
        [self setShouldStop:YES];
        return;
    }
    else
        [[self garden] moveUpTo:grade];
    
    while (![self shouldStop])
    {
        @try
        {
            [[self nursery] lock];
            
            NURegion aFreeRegion = [[[self nursery] spaces] nextParaderTargetFreeSpaceForLocation:nextLocation];

            if (aFreeRegion.location != NUNotFound64)
            {
                [self paradeObjectOrNodeNextTo:aFreeRegion];
            }
            else
            {
                [[[self nursery] spaces] minimizeSpace];
                nextLocation = 0;
                grade = NUNilGrade;
                
                break;
            }
        }
        @finally
        {
            [[self nursery] unlock];
        }
    }
    
#ifdef DEBUG
    NSLog(@"%@ process finished", self);
#endif
}

- (void)paradeObjectOrNodeNextTo:(NURegion)aFreeRegion
{
    nextLocation = NUMaxLocation(aFreeRegion);
    
    if (nextLocation < [[[self nursery] pages] nextPageLocation])
    {
        NUBellBall aBellBall = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:nextLocation];
        
        if (!NUBellBallEquals(aBellBall, NUNotFoundBellBall))
        {
            if (aBellBall.grade <= [self grade])
                [self paradeObjectWithBellBall:aBellBall at:nextLocation nextTo:aFreeRegion];
        }
        else
        {
            NUUInt64 aNodeLocation = NUMaxLocation(aFreeRegion);
            [self paradeNodeAt:aNodeLocation nextTo:aFreeRegion];
        }
        
#ifdef DEBUG
        BOOL aFreeRegionsIsValid = [[[self nursery] spaces] validateFreeRegions];
        
        if (aFreeRegionsIsValid)
            NSLog(@"aFreeRegionsIsValid = YES");
        else
            NSLog(@"aFreeRegionsIsValid = NO");
#endif
    }
}

- (void)paradeObjectWithBellBall:(NUBellBall)aBellBall at:(NUUInt64)anObjectLocation nextTo:(NURegion)aFreeRegion
{
    NUUInt64 anObjectSize = [(NUMainBranchAliaser *)[[self garden] aliaser] sizeOfObjectForBellBall:aBellBall];
    NUUInt8 *aBuffer = malloc((size_t)anObjectSize);
    NURegion aNewFreeRegion = NUMakeRegion(aFreeRegion.location + anObjectSize, aFreeRegion.length);
    [[[self nursery] pages] moveBytesAt:anObjectLocation length:anObjectSize to:aFreeRegion.location buffer:aBuffer length:anObjectSize];
    [[[self nursery] spaces] removeRegion:aFreeRegion];
    [[[self nursery] spaces] releaseSpace:aNewFreeRegion];
    [[[self nursery] objectTable] setObjectLocation:aFreeRegion.location for:aBellBall];
    [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:anObjectLocation];
    [[[self nursery] reversedObjectTable] setBellBall:aBellBall forObjectLocation:aFreeRegion.location];
    nextLocation = aNewFreeRegion.location;
    free(aBuffer);
}

- (void)paradeNodeAt:(NUUInt64)aNodeLocation nextTo:(NURegion)aFreeRegion
{
    if (aNodeLocation % [[[self nursery] pages] pageSize])
        [[NSException exceptionWithName:NUParaderInvalidNodeLocationException reason:nil userInfo:nil] raise];
    
    if ([[[self nursery] spaces] nodePageIsReleased:aNodeLocation])
    {
        [[[self nursery] spaces] releaseNodePage:aNodeLocation];
        [[[self nursery] spaces] removePageToReleaseAtLocation:aNodeLocation];
    }
    else
    {
        NURegion aMovedNodeRegion;
        NURegion aCurrentNodeRegion = NUMakeRegion(aNodeLocation, [[[[self nursery] spaces] pages] pageSize]);
        NURegion aNewFreeRegion1, aNewFreeRegion2;
        
        [self computeMovedNodeRegionInto:&aMovedNodeRegion fromCurrentNodeRegion:aCurrentNodeRegion withFreeRegion:aFreeRegion newFreeRegion1Into:&aNewFreeRegion1 newFreeRegion2Into:&aNewFreeRegion2];
    
        if (aMovedNodeRegion.location != NUNotFound64)
        {
            NUOpaqueBPlusTreeNode *aNode = [self nodeFor:aNodeLocation];
            
            if (aNode)
            {
                [aNode changeNodePageWith:aMovedNodeRegion.location];
                
                NUUInt8 *aBuffer = malloc((size_t)aCurrentNodeRegion.length);
                [[[self nursery] pages] moveBytesAt:aNodeLocation length:aCurrentNodeRegion.length to:aMovedNodeRegion.location buffer:aBuffer length:aCurrentNodeRegion.length];
                [[[self nursery] spaces] removeRegion:aFreeRegion];
                
                if (aNewFreeRegion1.length != 0)
                    [[[self nursery] spaces] releaseSpace:aNewFreeRegion1];
                
                [[[self nursery] spaces] releaseSpace:aNewFreeRegion2];
                free(aBuffer);
            }
            else
            {
                @throw  [NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
            }
        }
    }
}

- (void)computeMovedNodeRegionInto:(NURegion *)aMovedNodeRegion fromCurrentNodeRegion:(NURegion)aCurrentNodeRegion withFreeRegion:(NURegion)aFreeRegion newFreeRegion1Into:(NURegion *)aNewFreeRegion1 newFreeRegion2Into:(NURegion *)aNewFreeRegion2
{
    NUUInt64 aMovedLocation = aCurrentNodeRegion.length * (aFreeRegion.location / aCurrentNodeRegion.length);
    
    if (aMovedLocation < aFreeRegion.location)
        aMovedLocation += aCurrentNodeRegion.length;
    
    NURegion aTmpMovedNodeRegion = NUMakeRegion(aMovedLocation, aCurrentNodeRegion.length);
    
    if (!NURegionEquals(aTmpMovedNodeRegion, aFreeRegion) && NURegionInRegion(aTmpMovedNodeRegion, aFreeRegion))
    {
        NURegionSplitWithRegion(NUUnionRegion(aFreeRegion, aCurrentNodeRegion), aTmpMovedNodeRegion, aNewFreeRegion1, aNewFreeRegion2);
        
        if (aMovedNodeRegion)
            *aMovedNodeRegion = aTmpMovedNodeRegion;
    }
    else
    {
        if (aMovedNodeRegion)
            *aMovedNodeRegion = NUMakeRegion(NUNotFound64, 0);
        if (aNewFreeRegion1)
            *aNewFreeRegion1 = NUMakeRegion(NUNotFound64, 0);
        if (aNewFreeRegion2)
            *aNewFreeRegion2 = NUMakeRegion(NUNotFound64, 0);
    }
}

- (NUOpaqueBPlusTreeNode *)nodeFor:(NUUInt64)aNodeLocation
{
    NUOpaqueBPlusTreeNode *aNode = [[[self nursery] spaces] nodeFor:aNodeLocation];
    
    if (!aNode) aNode = [[[self nursery] objectTable] nodeFor:aNodeLocation];
    if (!aNode) aNode = [[[self nursery] reversedObjectTable] nodeFor:aNodeLocation];
    if (!aNode) aNode = [[[[self nursery] spaces] locationTree] nodeFor:aNodeLocation];
    if (!aNode) aNode = [[[[self nursery] spaces] lengthTree] nodeFor:aNodeLocation];
    
    return aNode;
}

@end
