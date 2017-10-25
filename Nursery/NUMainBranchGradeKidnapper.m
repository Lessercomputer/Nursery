//
//  NUMainBranchGradeKidnapper.m
//  Nursery
//
//  Created by P,T,A on 2013/11/03.
//
//

#import "NUMainBranchGradeKidnapper.h"
#import "NUBellBall.h"
#import "NUBell.h"
#import "NUPeephole.h"
#import "NUPlayLot.h"
#import "NUMainBranchNursery.h"
#import "NUObjectTable.h"

@implementation NUMainBranchGradeKidnapper

- (void)stalkIvarsOfObjectFor:(NUBell *)aBell
{
    NUMainBranchNursery *aNursery = (NUMainBranchNursery *)[[self playLot] nursery];
    
    @try
    {
        [[self playLot] lock];
        [aNursery lockForRead];
        
        NUUInt64 aGrade;
        [[aNursery objectTable] objectLocationForOOP:[aBell ball].oop gradeLessThanOrEqualTo:[self grade] gradeInto:&aGrade];
        NUBellBall aBellBall = NUMakeBellBall([aBell ball].oop, aGrade);
        [[self peephole] peekAt:aBellBall];
        
        while ([[self peephole] hasNextFixedOOP])
            [self pushBellIfNeeded:[[self playLot] bellForOOP:[[self peephole] nextFixedOOP]]];
        
        while ([[self peephole] hasNextIndexedOOP])
            [self pushBellIfNeeded:[[self playLot] bellForOOP:[[self peephole] nextIndexedOOP]]];
    }
    @finally
    {
        [aNursery unlockForRead];
        [[self playLot] unlock];
    }
}

@end
