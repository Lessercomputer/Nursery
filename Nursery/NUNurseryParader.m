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
                [[self nursery] paraderDidFinishParade:self];
                
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
            [self paradeObjectWithBellBall:aBellBall at:nextLocation nextTo:aFreeRegion];
        }
        else
        {
            NUUInt64 aNodeLocation = NUMaxLocation(aFreeRegion);
            [self paradeNodeAt:aNodeLocation nextTo:aFreeRegion];
        }
        
//#ifdef DEBUG
        BOOL aFreeRegionsIsValid = [[[self nursery] spaces] validateFreeRegions];
        
        if (aFreeRegionsIsValid)
            NSLog(@"aFreeRegionsIsValid = YES");
        else
            NSLog(@"aFreeRegionsIsValid = NO");
//#endif
    }
}

- (void)paradeObjectWithBellBall:(NUBellBall)aBellBall at:(NUUInt64)anObjectLocation nextTo:(NURegion)aFreeRegion
{
    NUUInt64 anObjectSize = [(NUMainBranchAliaser *)[[self garden] aliaser] sizeOfObjectForBellBall:aBellBall];
    NURegion anObjectRegion = NUMakeRegion(anObjectLocation, anObjectSize);
    NURegion aNewObjectRegion = NUMakeRegion(NUNotFound64, anObjectSize);
    
    [[[self nursery] spaces] releaseSpace:anObjectRegion];
    aNewObjectRegion.location = [[[self nursery] spaces] allocateSpace:anObjectSize];
    
    [[[self nursery] pages] copyBytesAt:anObjectRegion.location length:anObjectRegion.length to:aNewObjectRegion.location];
    [[[self nursery] objectTable] setObjectLocation:aNewObjectRegion.location for:aBellBall];
    [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:anObjectLocation];
    [[[self nursery] reversedObjectTable] setBellBall:aBellBall forObjectLocation:aNewObjectRegion.location];

    nextLocation = aNewObjectRegion.location;
}

- (void)paradeNodeAt:(NUUInt64)aNodeLocation nextTo:(NURegion)aFreeRegion
{
    NUUInt64 aNodeSize = [[[self nursery] pages] pageSize];
    if (aNodeLocation % aNodeSize)
        [[NSException exceptionWithName:NUParaderInvalidNodeLocationException reason:nil userInfo:nil] raise];
    
    if ([[[self nursery] spaces] nodePageIsNotToBeReleased:aNodeLocation])
    {
        NURegion aNodeRegion = NUMakeRegion(aNodeLocation, aNodeSize);
        [[[self nursery] spaces] releaseSpace:aNodeRegion];
        NUUInt64 aNewNodeLocation = [[[self nursery] spaces] allocateSpace:aNodeSize aligned:YES preventsNodeRelease:NO];

        if (aNodeLocation != aNewNodeLocation)
        {
            NUOpaqueBPlusTreeNode *aNode = [self nodeFor:aNodeLocation];

            if (aNode)
                [aNode changeNodePageWith:aNewNodeLocation];
            
            [[[self nursery] pages] copyBytesAt:aNodeLocation length:aNodeSize to:aNewNodeLocation];
        }
        else
            nextLocation = NUMaxLocation(aFreeRegion) + aNodeSize;
    }
    else
    {
        [[[self nursery] spaces] releaseNodePageLocation:aNodeLocation];
        [[[self nursery] spaces] removePageToBeReleasedAtLocation:aNodeLocation];
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
