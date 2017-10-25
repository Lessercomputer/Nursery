//
//  NUPeephole.h
//  Nursery
//
//  Created by P,T,A on 11/08/29.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@class NUNursery, NUCharacter, NUPlayLot;

@interface NUPeephole : NSObject
{
    NUCharacter *character;
    NUUInt64 currentFixedOOPIvarIndex;
	NUUInt64 currentIndexedOOPIndex;
    NUUInt64 indexedOOPCount;
}

+ (id)peepholeWithNursery:(NUNursery *)aNursery playLot:(NUPlayLot *)aPlayLot;

- (id)initWithNursery:(NUNursery *)aNursery playLot:(NUPlayLot *)aPlayLot;

- (void)peekAt:(NUBellBall)aBellBall;
- (BOOL)hasNextFixedOOP;
- (NUUInt64)nextFixedOOP;
- (BOOL)hasNextIndexedOOP;
- (NUUInt64)nextIndexedOOP;

- (NUCharacter *)character;
- (NUUInt64)fixedOOPCount;
- (NUUInt64)indexedOOPCount;

@end
