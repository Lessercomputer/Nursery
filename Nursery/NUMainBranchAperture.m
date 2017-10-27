//
//  NUMainBranchAperture.m
//  Nursery
//
//  Created by P,T,A on 2013/09/19.
//
//

#import "NUMainBranchAperture.h"
#import "NUMainBranchNursery.h"
#import "NUPages.h"
#import "NUCharacter.h"
#import "NUObjectTable.h"
#import "NUIvar.h"
#import "NUBellBall.h"

@implementation NUMainBranchAperture

- (id)initWithNursery:(NUNursery *)aNursery sandbox:(NUSandbox *)aSandbox
{
	if (self = [super initWithNursery:aNursery sandbox:aSandbox])
	{
        nursery = (NUMainBranchNursery *)aNursery;
        sandbox = (NUMainBranchSandbox *)aSandbox;
	}
    
	return self;
}

- (void)peekAt:(NUBellBall)aBellBall
{
	oop = aBellBall.oop;
	currentFixedOOPIvarIndex = 0;
	currentIndexedOOPIndex = 0;
    indexedOOPCount = 0;
	
	if (oop != NUNilOOP)
	{
        @try
        {
            [nursery lockForRead];
            
            objectLocation = [[nursery objectTable] objectLocationFor:aBellBall];
            if (objectLocation == NUNotFound64 || objectLocation == 0)
                [[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
            
            NUUInt64 aCharacterOOP = [[nursery pages] readUInt64At:objectLocation];
            character = [sandbox objectForOOP:aCharacterOOP];
            if ([character isIndexedIvars] || [character isFixedAndIndexedIvars])
                indexedOOPCount = [[nursery pages] readUInt64At:objectLocation + sizeof(NUUInt64)]
                / sizeof(NUUInt64);
        }
        @finally
        {
            [nursery unlockForRead];
        }
	}
	else
	{
		objectLocation = NUNotFound64;
		character = nil;
	}
}

- (NUUInt64)nextFixedOOP
{
	NUIvar *anIvar = [[self character] ivarInAllOOPIvarsAt:currentFixedOOPIvarIndex++];
	return [[nursery pages] readUInt64At:objectLocation + [anIvar offset]];
}

- (NUUInt64)nextIndexedOOP
{
	return [[nursery pages] readUInt64At:objectLocation + [[self character] indexedIvarOffset]
            + sizeof(NUUInt64) * currentIndexedOOPIndex++];
}


@end
