//
//  NUAperture.h
//  Nursery
//
//  Created by Akifumi Takata on 11/08/29.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@class NUNursery, NUCharacter, NUSandbox;

@interface NUAperture : NSObject
{
    NUCharacter *character;
    NUUInt64 currentFixedOOPIvarIndex;
	NUUInt64 currentIndexedOOPIndex;
    NUUInt64 indexedOOPCount;
}

+ (id)apertureWithNursery:(NUNursery *)aNursery sandbox:(NUSandbox *)aSandbox;

- (id)initWithNursery:(NUNursery *)aNursery sandbox:(NUSandbox *)aSandbox;

- (void)peekAt:(NUBellBall)aBellBall;
- (BOOL)hasNextFixedOOP;
- (NUUInt64)nextFixedOOP;
- (BOOL)hasNextIndexedOOP;
- (NUUInt64)nextIndexedOOP;

- (NUCharacter *)character;
- (NUUInt64)fixedOOPCount;
- (NUUInt64)indexedOOPCount;

@end
