//
//  NUMainBranchGradeSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/03.
//
//

#import "NUMainBranchGradeSeeker.h"
#import "NUBellBall.h"
#import "NUBell.h"
#import "NUAperture.h"
#import "NUSandbox.h"
#import "NUMainBranchNursery.h"
#import "NUObjectTable.h"

@implementation NUMainBranchGradeSeeker

- (void)seekIvarsOfObjectFor:(NUBell *)aBell
{
    NUMainBranchNursery *aNursery = (NUMainBranchNursery *)[[self sandbox] nursery];
    
    @try
    {
        [[self sandbox] lock];
        [aNursery lockForRead];
        
        NUUInt64 aGrade;
        [[aNursery objectTable] objectLocationForOOP:[aBell ball].oop gradeLessThanOrEqualTo:[self grade] gradeInto:&aGrade];
        NUBellBall aBellBall = NUMakeBellBall([aBell ball].oop, aGrade);
        [[self aperture] peekAt:aBellBall];
        
        while ([[self aperture] hasNextFixedOOP])
            [self pushBellIfNeeded:[[self sandbox] bellForOOP:[[self aperture] nextFixedOOP]]];
        
        while ([[self aperture] hasNextIndexedOOP])
            [self pushBellIfNeeded:[[self sandbox] bellForOOP:[[self aperture] nextIndexedOOP]]];
    }
    @finally
    {
        [aNursery unlockForRead];
        [[self sandbox] unlock];
    }
}

@end
