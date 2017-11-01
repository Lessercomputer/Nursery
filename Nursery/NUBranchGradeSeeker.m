//
//  NUBranchGradeSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/01.
//
//

#import "NUBranchGradeSeeker.h"
#import "NUBranchSandbox.h"
#import "NUBranchAliaser.h"
#import "NUAperture.h"
#import "NUBell.h"

@implementation NUBranchGradeSeeker

- (void)seekIvarsOfObjectFor:(NUBell *)aBell
{    
    [[self aperture] peekAt:aBell.ball];
    
    while ([[self aperture] hasNextFixedOOP])
        [self pushBellIfNeeded:[[self sandbox] bellForOOP:[[self aperture] nextFixedOOP]]];
    
    while ([[self aperture] hasNextIndexedOOP])
        [self pushBellIfNeeded:[[self sandbox] bellForOOP:[[self aperture] nextIndexedOOP]]];
}

@end
