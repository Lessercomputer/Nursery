//
//  NUMainBranchGardenSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/03.
//
//

#import "NUMainBranchGardenSeeker.h"
#import "NUBellBall.h"
#import "NUBell.h"
#import "NUAperture.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUObjectTable.h"

@implementation NUMainBranchGardenSeeker

- (void)seekIvarsOfObjectFor:(NUBell *)aBell
{
    NUMainBranchNursery *aNursery = (NUMainBranchNursery *)[[self garden] nursery];
    
    @try
    {
        [[self garden] lock];
        [aNursery lockForRead];
        
        NUUInt64 aGrade;
        [[aNursery objectTable] objectLocationForOOP:[aBell ball].oop gradeLessThanOrEqualTo:[self grade] gradeInto:&aGrade];
        NUBellBall aBellBall = NUMakeBellBall([aBell ball].oop, aGrade);
        [[self aperture] peekAt:aBellBall];
        
        while ([[self aperture] hasNextFixedOOP])
            [self pushBellIfNeeded:[[self garden] bellForOOP:[[self aperture] nextFixedOOP]]];
        
        while ([[self aperture] hasNextIndexedOOP])
            [self pushBellIfNeeded:[[self garden] bellForOOP:[[self aperture] nextIndexedOOP]]];
    }
    @finally
    {
        [aNursery unlockForRead];
        [[self garden] unlock];
    }
}

@end
