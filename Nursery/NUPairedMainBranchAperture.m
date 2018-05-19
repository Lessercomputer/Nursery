//
//  NUPairedMainBranchAperture.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/05/19.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUPairedMainBranchAperture.h"
#import "NUGarden+Project.h"
#import "NUPairedMainBranchGarden.h"
#import "NUNurseryNetResponder.h"
#import "NUPupilNoteCache.h"
#import "NUCharacter.h"
#import "NUPupilNote.h"
#import "NUIvar.h"

@implementation NUPairedMainBranchAperture

- (id)initWithNursery:(NUNursery *)aNursery garden:(NUGarden *)aGarden
{
    if (self = [super initWithNursery:aNursery garden:aGarden])
    {
        _nursery = (NUMainBranchNursery *)aNursery;
        _garden = (NUPairedMainBranchGarden *)aGarden;
    }
    
    return self;
}

- (void)peekAt:(NUBellBall)aBellBall
{
    currentFixedOOPIvarIndex = 0;
    currentIndexedOOPIndex = 0;
    indexedOOPCount = 0;
    
    [self setPupilNote:[[[self responder] pupilNoteCache] pupilNoteForOOP:aBellBall.oop grade:[[self garden] grade]]];
    
    NUUInt64 aCharacterOOP = [[self pupilNote] readUInt64At:0];
    character = [[self garden] objectForOOP:aCharacterOOP];
    
    if ([character isIndexedIvars] || [character isFixedAndIndexedIvars])
        indexedOOPCount = [[self pupilNote] readUInt64At:sizeof(NUUInt64)] / sizeof(NUUInt64);
}

- (NUUInt64)nextFixedOOP
{
    NUIvar *anIvar = [[self character] ivarInAllOOPIvarsAt:currentFixedOOPIvarIndex++];
    return [[self pupilNote] readUInt64At:[anIvar offset]];
}

- (NUUInt64)nextIndexedOOP
{
    return [[self pupilNote] readUInt64At:[[self character] indexedIvarOffset] + sizeof(NUUInt64) * currentIndexedOOPIndex++];
}

@end
