//
//  NUNurseryParader.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#include <stdlib.h>
#import <Foundation/NSException.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSSet.h>

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
        movedObjectLocations = [NSMutableArray new];
        movedNodeLocations = [NSMutableArray new];
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

- (void)setGrade:(NUUInt64)aGrade
{
//    #ifdef DEBUG
    NSLog(@"%@ currentGrade:%@, aNewGrade:%@", self, @(grade), @(aGrade));
//    #endif
    
    grade = aGrade;
}

- (void)save
{
    [[[self nursery] pages] writeUInt64:nextLocation at:NUParaderNextLocationOffset];
}

- (void)load
{
    nextLocation = [[[self nursery] pages] readUInt64At:NUParaderNextLocationOffset];
}

- (void)processOneUnit
{
    @try
    {
        [[self nursery] lock];
 
        NSDate *aStopDate = [NSDate dateWithTimeIntervalSinceNow:0.001];

        if ([self grade] != [[self nursery] gradeForParader])
        {
            [self setGrade:[[self nursery] gradeForParader]];
            [[self garden] moveUpTo:[self grade]];
            nextLocation = 0;
        }
        
        while ([aStopDate timeIntervalSinceNow] > 0)
        {
            NURegion aFreeRegion = [[[self nursery] spaces] freeSpaceBeginningAtLocationGreaterThanOrEqual:nextLocation];
            
            if (aFreeRegion.location != NUNotFound64)
            {
                [self paradeObjectOrNodeNextTo:aFreeRegion];
            }
            else if (nextLocation)
            {
                nextLocation = 0;
                NSLog(@"%@:didFinishParade", self);
                [[[self nursery] spaces] minimizeSpace];
                [[self nursery] paraderDidFinishParade:self];
                //                [[[self nursery] spaces] validate];
                //                [[self nursery] validateMappingOfObjectTableToReversedObjectTable];

                break;
            }
        }
    }
    @finally
    {
        [[self nursery] unlock];
    }
}

- (void)paradeObjectOrNodeNextTo:(NURegion)aFreeRegion
{
    nextLocation = NUMaxLocation(aFreeRegion);
    if (nextLocation == 20735)
        [self class];
    
    if (nextLocation < [[[self nursery] pages] nextPageLocation])
    {
        NUBellBall aBellBall = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:nextLocation];
        
        if (!NUBellBallEquals(aBellBall, NUNotFoundBellBall))
        {
//            [[self nursery] validateMappingOfObjectTableToReversedObjectTable];
//            if (NUBellBallEquals([[[self nursery] reversedObjectTable] bellBallForObjectLocation:28390], NUNotFoundBellBall))
//                [self class];
            [self paradeObjectWithBellBall:aBellBall at:nextLocation nextTo:aFreeRegion];
//            [[self nursery] validateMappingOfObjectTableToReversedObjectTable];
//            if (NUBellBallEquals([[[self nursery] reversedObjectTable] bellBallForObjectLocation:28390], NUNotFoundBellBall))
//                [self class];
        }
        else
        {
            NUUInt64 aNodeSize = [[[self nursery] pages] pageSize];
            
            if (nextLocation % aNodeSize == 0)
            {
//                if (NUBellBallEquals([[[self nursery] reversedObjectTable] bellBallForObjectLocation:28390], NUNotFoundBellBall))
//                    [self class];
//                [[self nursery] validateMappingOfObjectTableToReversedObjectTable];
                [self paradeNodeAt:nextLocation nextTo:aFreeRegion];
//                [[self nursery] validateMappingOfObjectTableToReversedObjectTable];
//                if (NUBellBallEquals([[[self nursery] reversedObjectTable] bellBallForObjectLocation:28390], NUNotFoundBellBall))
//                    [self class];
            }
            else
            {
                NUBellBall aScannedBellBall = [[[self nursery] reversedObjectTable] scanBellBallForObjectLocation:nextLocation];
                NUBellBall aBellBall2 = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:nextLocation];
                if (!NUBellBallEquals(aBellBall2, aBellBall) || !NUBellBallEquals(aScannedBellBall, aBellBall))
                {
//                    [self class];
                    NUBellBall aBellBall3 = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:nextLocation];
                }
//                [[self nursery] validateMappingOfObjectTableToReversedObjectTable];
                [[NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil] raise];
            }
        }
//        [[self nursery] validateMappingOfObjectTableToReversedObjectTable];
//        [[[self nursery] spaces] validate];
    }
}

- (void)paradeObjectWithBellBall:(NUBellBall)aBellBall at:(NUUInt64)anObjectLocation nextTo:(NURegion)aFreeRegion
{
    NUUInt64 anObjectSize = [(NUMainBranchAliaser *)[[self garden] aliaser] sizeOfObjectForBellBall:aBellBall];
    NURegion anObjectRegion = NUMakeRegion(anObjectLocation, anObjectSize);
    NURegion aNewObjectRegion = NUMakeRegion(NUNotFound64, anObjectSize);

    if (anObjectLocation == 20719)
        [self class];
    [[[self nursery] spaces] releaseSpace:anObjectRegion];
    aNewObjectRegion.location = [[[self nursery] spaces] allocateSpace:anObjectSize aligned:NO preventsNodeRelease:YES];

    if (aNewObjectRegion.location == NUNotFound64 || !aNewObjectRegion.location)
        @throw [NSException exceptionWithName:NSGenericException reason:nil userInfo:nil];

    [[[self nursery] pages] copyBytesAt:anObjectRegion.location length:anObjectRegion.length to:aNewObjectRegion.location];
    [[[self nursery] objectTable] setObjectLocation:aNewObjectRegion.location for:aBellBall];
    
    NUBellBall aBellBall2 = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:28390];
    if (NUBellBallEquals(aBellBall2, NUNotFoundBellBall))
        [self class];
    
    [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:anObjectLocation];
    
    NUBellBall aBellBall3 = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:28390];
    if (NUBellBallEquals(aBellBall3, NUNotFoundBellBall))
        [self class];
    
    [[[self nursery] reversedObjectTable] setBellBall:aBellBall forObjectLocation:aNewObjectRegion.location];
    [movedObjectLocations addObject:[NSString stringWithFormat:@"old location:%@, new location:%@, size:%@, bellball:%@", @(anObjectLocation), @(aNewObjectRegion.location), @(anObjectSize), NUStringFromBellBall(aBellBall), nil]];

    nextLocation = NUMaxLocation(anObjectRegion);
    if (nextLocation == 20735)
        [self class];
}

- (void)paradeNodeAt:(NUUInt64)aNodeLocation nextTo:(NURegion)aFreeRegion
{
    NUUInt64 aNodeSize = [[[self nursery] pages] pageSize];

    if ([[[self nursery] spaces] nodePageIsNotToBeReleased:aNodeLocation])
    {
        NURegion aNodeRegion = NUMakeRegion(aNodeLocation, aNodeSize);

        [[[self nursery] spaces] releaseSpace:aNodeRegion];
        NUUInt64 aNewNodeLocation = [[[self nursery] spaces] allocateNodePageLocationWithPreventNodeRelease];

        if (aNodeLocation != aNewNodeLocation)
        {
            NUOpaqueBPlusTreeNode *aNode = [[[self nursery] spaces] nodeFor:aNodeLocation];

            if (aNode)
            {
                [aNode changeNodePageWith:aNewNodeLocation];
                [[[self nursery] pages] copyBytesAt:aNodeLocation length:aNodeSize to:aNewNodeLocation];
                [movedNodeLocations addObject:[NSString stringWithFormat:@"old node location:%@, new node location:%@", @(aNodeLocation), @(aNewNodeLocation), nil]];
            }
            else
                @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
        }
    }

    nextLocation = NUMaxLocation(aFreeRegion);

    if (nextLocation == 20735)
        [self class];
}

@end
