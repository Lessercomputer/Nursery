//
//  NUBranchGradeKidnapper.m
//  Nursery
//
//  Created by P,T,A on 2014/03/01.
//
//

#import "NUBranchGradeKidnapper.h"
#import "NUBranchPlayLot.h"
#import "NUBranchAliaser.h"
#import "NUPeephole.h"

@implementation NUBranchGradeKidnapper

- (void)stalkIvarsOfObjectFor:(NUBell *)aBell
{    
    [[self peephole] peekAt:aBell.ball];
    
    while ([[self peephole] hasNextFixedOOP])
        [self pushBellIfNeeded:[[self playLot] bellForOOP:[[self peephole] nextFixedOOP]]];
    
    while ([[self peephole] hasNextIndexedOOP])
        [self pushBellIfNeeded:[[self playLot] bellForOOP:[[self peephole] nextIndexedOOP]]];
}

@end
