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
#ifdef DEBUG
    NSLog(@"%@ currentGrade:%@, aNewGrade:%@", self, @(grade), @(aGrade));
#endif
    
    grade = aGrade;
}

- (void)save
{
    [[self nursery] lock];
    
    [[[self nursery] pages] writeUInt64:nextLocation at:NUParaderNextLocationOffset];
    [self setIsLoaded:YES];
    
    [[self nursery] unlock];
}

- (void)load
{
    [[self nursery] lock];
    
    nextLocation = [[[self nursery] pages] readUInt64At:NUParaderNextLocationOffset];
    [self setIsLoaded:YES];
    
    [[self nursery] unlock];
}

- (BOOL)processOneUnit
{
    BOOL aProcessed = NO;

    @try
    {
        [[self garden] lock];
        [[self nursery] lock];
 
        if ([self grade] != [[self nursery] gradeForParader])
        {
            [self setGrade:[[self nursery] gradeForParader]];
            [[self garden] moveUpTo:[self grade]];
            nextLocation = 0;
        }
        
        NURegion aFreeRegion = [[[self nursery] spaces] freeSpaceBeginningAtLocationGreaterThanOrEqual:nextLocation];
        
        if (aFreeRegion.location != NUNotFound64)
        {
            aProcessed = [self paradeObjectOrNodeNextTo:aFreeRegion];
        }
        else if (nextLocation)
        {
            nextLocation = 0;
            aProcessed = [[[self nursery] spaces] minimizeSpaceIfPossible];
            [[self nursery] paraderDidFinishParade:self];
#ifdef DEBUG
            NSLog(@"%@:didFinishParade", self);
#endif
        }
        else
        {
            aProcessed = NO;
        }
    }
    @finally
    {
        [[self nursery] unlock];
        [[self garden] unlock];
    }
    
    return aProcessed;
}

- (BOOL)paradeObjectOrNodeNextTo:(NURegion)aFreeRegion
{
    BOOL anObjectOrNodeMoved = NO;
    
    nextLocation = NUMaxLocation(aFreeRegion);

    if (nextLocation < [[[self nursery] pages] nextPageLocation])
    {
        NUBellBall aBellBall = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:nextLocation];
        
        if (!NUBellBallEquals(aBellBall, NUNotFoundBellBall))
        {
            anObjectOrNodeMoved = [self paradeObjectWithBellBall:aBellBall at:nextLocation nextTo:aFreeRegion];
        }
        else
        {
            NUUInt64 aNodeSize = [[[self nursery] pages] pageSize];
            
            if (nextLocation % aNodeSize == 0)
            {
                anObjectOrNodeMoved = [self paradeNodeAt:nextLocation nextTo:aFreeRegion];
            }
            else
            {
                [[NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil] raise];
            }
        }
    }
    
    return anObjectOrNodeMoved;
}

- (BOOL)paradeObjectWithBellBall:(NUBellBall)aBellBall at:(NUUInt64)anObjectLocation nextTo:(NURegion)aFreeRegion
{
    BOOL anObjectMoved = NO;
    
    NUUInt64 anObjectSize = [self sizeOfObjectForBellBall:aBellBall];
    NURegion anObjectRegion = NUMakeRegion(anObjectLocation, anObjectSize);
    NURegion aNewObjectRegion = NUMakeRegion(NUNotFound64, anObjectSize);

    [[[self nursery] spaces] releaseSpace:anObjectRegion];
    aNewObjectRegion.location = [[[self nursery] spaces] allocateSpace:anObjectSize aligned:NO preventsNodeRelease:NO];

    if (aNewObjectRegion.location == NUNotFound64 || !aNewObjectRegion.location)
        @throw [NSException exceptionWithName:NSGenericException reason:nil userInfo:nil];

    if (anObjectRegion.location != aNewObjectRegion.location)
    {
        [[[self nursery] pages] copyBytesAt:anObjectRegion.location length:anObjectRegion.length to:aNewObjectRegion.location];
        [[[self nursery] objectTable] setObjectLocation:aNewObjectRegion.location for:aBellBall];
        
        [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:anObjectLocation];
        [[[self nursery] reversedObjectTable] setBellBall:aBellBall forObjectLocation:aNewObjectRegion.location];
        anObjectMoved = YES;
    }
    
    nextLocation = NUMaxLocation(anObjectRegion);
    
    return anObjectMoved;
}

- (BOOL)paradeNodeAt:(NUUInt64)aNodeLocation nextTo:(NURegion)aFreeRegion
{
    BOOL aNodeMoved = NO;
    
    NUUInt64 aNodeSize = [[[self nursery] pages] pageSize];

    if ([[[self nursery] spaces] nodePageIsNotToBeReleased:aNodeLocation])
    {
        NUOpaqueBPlusTreeNode *aNode = [[[self nursery] spaces] nodeFor:aNodeLocation];
        
        if (aNode)
        {
            NURegion aNodeRegion = NUMakeRegion(aNodeLocation, aNodeSize);
            
            [[[self nursery] spaces] releaseSpace:aNodeRegion];
            NUUInt64 aNewNodeLocation = [[[self nursery] spaces] allocateNodePageLocation];

            if (aNodeLocation != aNewNodeLocation)
            {
                [aNode changeNodePageWith:aNewNodeLocation];
                [[[self nursery] pages] copyBytesAt:aNodeLocation length:aNodeSize to:aNewNodeLocation];
                aNodeMoved = YES;
            }
        }
    }

    nextLocation = NUMaxLocation(aFreeRegion);
    
    return aNodeMoved;
}

- (NUUInt64)sizeOfObjectForBellBall:(NUBellBall)aBellBall
{
    NUUInt64 anObjectSize = [(NUMainBranchAliaser *)[[self garden] aliaser] sizeOfObjectForBellBall:aBellBall];
    return anObjectSize;
}

@end
