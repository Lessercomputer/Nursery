//
//  NUAperture.h
//  Nursery
//
//  Created by Akifumi Takata on 11/08/29.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUTypes.h"

@class NUNursery, NUCharacter, NUGarden;

@interface NUAperture : NSObject
{
    NUCharacter *character;
    NUUInt64 currentFixedOOPIvarIndex;
	NUUInt64 currentIndexedOOPIndex;
    NUUInt64 indexedOOPCount;
}

+ (id)apertureWithNursery:(NUNursery *)aNursery garden:(NUGarden *)aGarden;

- (id)initWithNursery:(NUNursery *)aNursery garden:(NUGarden *)aGarden;

- (void)peekAt:(NUBellBall)aBellBall;
- (BOOL)hasNextFixedOOP;
- (NUUInt64)nextFixedOOP;
- (BOOL)hasNextIndexedOOP;
- (NUUInt64)nextIndexedOOP;

- (NUCharacter *)character;
- (NUUInt64)fixedOOPCount;
- (NUUInt64)indexedOOPCount;

@end
