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

const NUUInt64 NUParaderNextLocationOffset = 69;
const NUUInt64 NUParaderGradeOffset = 133;

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

- (void)save
{
    [[[self nursery] pages] writeUInt64:nextLocation at:NUParaderNextLocationOffset];
    [[[self nursery] pages] writeUInt64:grade at:NUParaderGradeOffset];
}

- (void)load
{
    nextLocation = [[[self nursery] pages] readUInt64At:NUParaderNextLocationOffset];
    [[[self nursery] pages] readUInt64At:NUParaderGradeOffset];
}

- (void)process
{
    if (grade == NUNilGrade)
    {
        grade = [[self nursery] gradeForParader];
        
        if (grade == NUNilGrade)
        {
            [self setShouldStop:YES];
            return;
        }
    }
    
    if (grade != NUNilGrade)
        [[self garden] moveUpTo:grade];
    
    NUUInt64 aBufferSize = [[[self nursery] pages] pageSize];
    NUUInt8 *aBuffer = malloc((size_t)aBufferSize);
    
    while (![self shouldStop])
    {
        @try
        {
            [[self nursery] lock];
            
            NURegion aFreeRegion = [[[self nursery] spaces] nextParaderTargetFreeSpaceForLocation:nextLocation];
#ifdef DEBUG
            NSLog(@"aFreeRegion:%@", NUStringFromRegion(aFreeRegion));
#endif
            if (aFreeRegion.location != NUNotFound64)
            {
                [self paradeObjectOrNodeNextTo:aFreeRegion buffer:aBuffer bufferSize:aBufferSize];
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
    
    free(aBuffer);
    
#ifdef DEBUG
    NSLog(@"%@ process finished", self);
#endif
}

- (void)paradeObjectOrNodeNextTo:(NURegion)aFreeRegion buffer:(NUUInt8 *)aBuffer bufferSize:(NUUInt64) aBufferSize
{
    nextLocation = NUMaxLocation(aFreeRegion);
    
    if (nextLocation < [[[self nursery] pages] nextPageLocation])
    {
        NUBellBall aBellBall = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:nextLocation];
        
        if (!NUBellBallEquals(aBellBall, NUNotFoundBellBall))
        {
            [self paradeObjectWithBellBall:aBellBall atNextTo:aFreeRegion buffer:aBuffer bufferSize:aBufferSize];
        }
        else
        {
            [self paradeNodeAtNextTo:aFreeRegion buffer:aBuffer bufferSize:aBufferSize];
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

- (void)paradeObjectWithBellBall:(NUBellBall)aBellBall atNextTo:(NURegion)aFreeRegion buffer:(NUUInt8 *)aBuffer bufferSize:(NUUInt64)aBufferSize
{
#ifdef DEBUG
    NSLog(@"#paradeObject nextLocation:%llu bellBall:%@ freeRegion:%@", nextLocation, NUStringFromBellBall(aBellBall), NUStringFromRegion(aFreeRegion));
#endif
    
    NUUInt64 anObjectSize = [(NUMainBranchAliaser *)[[self garden] aliaser] sizeOfObjectForBellBall:aBellBall];
    NURegion aNewFreeRegion = NUMakeRegion(aFreeRegion.location + anObjectSize, aFreeRegion.length);
    [[[self nursery] pages] moveBytesAt:nextLocation length:anObjectSize to:aFreeRegion.location buffer:aBuffer length:aBufferSize];
    [[[self nursery] spaces] removeRegion:aFreeRegion];
    [[[self nursery] spaces] releaseSpace:aNewFreeRegion];
    [[[self nursery] objectTable] setObjectLocation:aFreeRegion.location for:aBellBall];
    [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:nextLocation];
    [[[self nursery] reversedObjectTable] setBellBall:aBellBall forObjectLocation:aFreeRegion.location];
    nextLocation = aNewFreeRegion.location;
}

- (void)paradeNodeAtNextTo:(NURegion)aFreeRegion buffer:(NUUInt8 *)aBuffer bufferSize:(NUUInt64)aBufferSize
{
#ifdef DEBUG
    NSLog(@"#paradeNode nextLocation:%llu freeRegion:%@", nextLocation, NUStringFromRegion(aFreeRegion));
#endif
    
    NURegion aMovedNodeRegion;
    NURegion aCurrentNodeRegion = NUMakeRegion(nextLocation, [[[[self nursery] spaces] pages] pageSize]);
    NURegion aNewFreeRegion1, aNewFreeRegion2;
    
    if (nextLocation % [[[self nursery] pages] pageSize])
        [[NSException exceptionWithName:NUParaderInvalidNodeLocationException reason:NUParaderInvalidNodeLocationException userInfo:nil] raise];
    
    if ([[[self nursery] spaces] nodePageLocationIsVirtual:nextLocation])
        NSLog(@"nextLocationIsVirtualPage:%@", @(nextLocation));
    
    [self computeMovedNodeRegionInto:&aMovedNodeRegion fromCurrentNodeRegion:aCurrentNodeRegion withFreeRegion:aFreeRegion newFreeRegion1Into:&aNewFreeRegion1 newFreeRegion2Into:&aNewFreeRegion2];
    
#ifdef DEBUG
    NSLog(@"aMovedNodeRegion:%@, aCurrentNodeRegion:%@, aFreeRegion:%@, newFreeRegion1:%@, aNewFreeRegion2:%@", NUStringFromRegion(aMovedNodeRegion), NUStringFromRegion(aCurrentNodeRegion), NUStringFromRegion(aFreeRegion), NUStringFromRegion(aNewFreeRegion1), NUStringFromRegion(aNewFreeRegion2));
#endif
    
    if (aMovedNodeRegion.location != NUNotFound64)
    {
        if ([[[self nursery] spaces] nodePageIsNotRelesed:nextLocation])
        {
#ifdef DEBUG
            NSLog(@"[[self nursery] spaces] nodePageIsNotRelesed:%@] == YES", @(nextLocation));
#endif
            NUOpaqueBPlusTreeNode *aNode = [[[self nursery] spaces] nodeFor:aCurrentNodeRegion.location];
#ifdef DEBUG
            NUOpaqueBPlusTreeBranch *aParentNode = [aNode parentNode];
            NUOpaqueBPlusTreeNode *aLeftNode = ![aNode isMostLeftNodeInCurrentDepth] ? [[[aNode leftNode] retain] autorelease] : nil;
            NUOpaqueBPlusTreeNode *aRightNode = ![aNode isMostRightNodeInCurrentDepth] ? [[[aNode rightNode] retain] autorelease] : nil;
            NUPage *aPageForParentNode = ![aNode isRoot] && [aParentNode pageIsNotVirtual] ? [[[self nursery] pages] pageAt:[aParentNode pageLocation]] : nil;
            NUPage *aPageForLeftNode = aLeftNode && [aLeftNode pageIsNotVirtual] ? [[[self nursery] pages] pageAt:[aLeftNode pageLocation]] : nil;
            NUPage *aPageForRightNode = aRightNode && [aRightNode pageIsNotVirtual] ? [[[self nursery] pages] pageAt:[aRightNode pageLocation]] : nil;

            NSLog(@"changeNodePage originalNodePageLocation:%@, newNodePageLocation:%@",  @([aNode pageLocation]), @(aMovedNodeRegion.location));
#endif
            [aNode changeNodePageWith:aMovedNodeRegion.location];
#ifdef DEBUG
            if (aPageForParentNode && ![aPageForParentNode isChanged])
                NSLog(@"parent page is not changed");
            if (aPageForLeftNode && ![aPageForLeftNode isChanged])
                NSLog(@"left page is not changed");
            if (aPageForRightNode && ![aPageForRightNode isChanged])
                NSLog(@"right page is not changed");
#endif
            [[[self nursery] pages] moveBytesAt:aCurrentNodeRegion.location length:aCurrentNodeRegion.length to:aMovedNodeRegion.location buffer:aBuffer length:aBufferSize];
        }
        else
        {
#ifdef DEBUG
            NSLog(@"[[self nursery] spaces] nodePageIsNotRelesed:%@] == NO", @(nextLocation));
#endif
            [[[self nursery] spaces] movePageToReleaseAtLocation:aCurrentNodeRegion.location toLocation:aMovedNodeRegion.location];
        }
#ifdef DEBUG
        if (aMovedNodeRegion.location % [[[self nursery] pages] pageSize])
            NSLog(@"aMovedNoreRegion.location %@", @(aMovedNodeRegion.location));
#endif
        [[[self nursery] spaces] removeRegion:aFreeRegion];
        
        if (aNewFreeRegion1.length != 0)
            [[[self nursery] spaces] releaseSpace:aNewFreeRegion1];
        
        [[[self nursery] spaces] releaseSpace:aNewFreeRegion2];
                
        nextLocation = aNewFreeRegion2.location;
    }
    else
        nextLocation = NUMaxLocation(aCurrentNodeRegion);    
}

- (void)computeMovedNodeRegionInto:(NURegion *)aMovedNodeRegion fromCurrentNodeRegion:(NURegion)aCurrentNodeRegion withFreeRegion:(NURegion)aFreeRegion newFreeRegion1Into:(NURegion *)aNewFreeRegion1 newFreeRegion2Into:(NURegion *)aNewFreeRegion2
{
    NUUInt64 aMovedLocation = aCurrentNodeRegion.length * (aFreeRegion.location / aCurrentNodeRegion.length);
    
    if (aMovedLocation < aFreeRegion.location)
        aMovedLocation += aCurrentNodeRegion.length;
    
    NURegion aTmpMovedNodeRegion = NUMakeRegion(aMovedLocation, aCurrentNodeRegion.length);
    
    if (!NURegionEquals(aTmpMovedNodeRegion, aFreeRegion) && NURegionInRegion(aTmpMovedNodeRegion, aFreeRegion))
    {
#ifdef DEBUG
        NSLog(@"NURegionInRegion(aTmpMovedNodeRegion, aFreeRegion) == YES");
#endif
        
        NURegionSplitWithRegion(NUUnionRegion(aFreeRegion, aCurrentNodeRegion), aTmpMovedNodeRegion, aNewFreeRegion1, aNewFreeRegion2);
        
        if (aMovedNodeRegion)
            *aMovedNodeRegion = aTmpMovedNodeRegion;
    }
    else
    {
#ifdef DEBUG
        NSLog(@"NURegionInRegion(aTmpMovedNodeRegion, aFreeRegion) == NO");
#endif
        
        if (aMovedNodeRegion)
            *aMovedNodeRegion = NUMakeRegion(NUNotFound64, 0);
        if (aNewFreeRegion1)
            *aNewFreeRegion1 = NUMakeRegion(NUNotFound64, 0);
        if (aNewFreeRegion2)
            *aNewFreeRegion2 = NUMakeRegion(NUNotFound64, 0);
    }
}

@end
