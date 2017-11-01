//
//  NUBranchAperture.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/09/19.
//
//

#import "NUBranchAperture.h"
#import "NUBranchNursery.h"
#import "NUBranchSandbox.h"
#import "NUBranchAliaser.h"
#import "NUPupilNote.h"
#import "NUObjectTable.h"
#import "NUCharacter.h"
#import "NUIvar.h"

@implementation NUBranchAperture

- (id)initWithNursery:(NUNursery *)aNursery sandbox:(NUSandbox *)aSandbox
{
    if (self = [super initWithNursery:aNursery sandbox:aSandbox])
    {
        nursery = (NUBranchNursery *)aNursery;
        sandbox = (NUBranchSandbox *)aSandbox;
    }
    
    return self;
}

- (void)peekAt:(NUBellBall)aBellBall
{
    NUBranchAliaser *anAliaser = (NUBranchAliaser *)[sandbox aliaser];
    
    currentFixedOOPIvarIndex = 0;
	currentIndexedOOPIndex = 0;
    indexedOOPCount = 0;

    if (aBellBall.oop != NUNilOOP)
    {
        [pupilNote release];
        pupilNote = [[anAliaser callForPupilNoteWithBellBall:aBellBall] retain];
        
        NUUInt64 aCharacterOOP = [pupilNote readUInt64At:0];
        character = [sandbox objectForOOP:aCharacterOOP];
        if ([character isIndexedIvars] || [character isFixedAndIndexedIvars])
            indexedOOPCount = [pupilNote readUInt64At:sizeof(NUUInt64)] / sizeof(NUUInt64);
    }
    else
    {
        [pupilNote release];
        pupilNote = nil;
    }
}

- (NUUInt64)nextFixedOOP
{
    NUIvar *anIvar = [[self character] ivarInAllOOPIvarsAt:currentFixedOOPIvarIndex++];
    return [pupilNote readUInt64At:[anIvar offset]];
}

- (NUUInt64)nextIndexedOOP
{
    return [pupilNote readUInt64At:[[self character] indexedIvarOffset] + sizeof(NUUInt64) * currentIndexedOOPIndex++];
}

@end
