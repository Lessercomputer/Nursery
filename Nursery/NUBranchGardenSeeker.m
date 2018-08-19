//
//  NUBranchGardenSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/01.
//
//

#import "NUBranchGardenSeeker.h"
#import "NUGarden+Project.h"
#import "NUBranchGarden.h"
#import "NUBranchAliaser.h"
#import "NUAperture.h"
#import "NUBell.h"

@implementation NUBranchGardenSeeker

- (void)seekIvarsOfObjectFor:(NUBell *)aBell
{
    [[self garden] lock];
    
    [[self aperture] peekAt:aBell.ball];
    
    while ([[self aperture] hasNextFixedOOP])
        [self pushBellIfNeeded:[[self garden] bellForOOP:[[self aperture] nextFixedOOP]]];
    
    while ([[self aperture] hasNextIndexedOOP])
        [self pushBellIfNeeded:[[self garden] bellForOOP:[[self aperture] nextIndexedOOP]]];
    
    [[self garden] unlock];
}

@end
