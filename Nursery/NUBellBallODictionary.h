//
//  NUBellBallODictionary.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/02/14.
//
//

#import "NUOpaqueODictionary.h"

@interface NUBellBallODictionary : NUOpaqueODictionary

- (void)setObject:(id)anObject forKey:(NUBellBall)aKey;
- (id)objectForKey:(NUBellBall)aKey;
- (void)removeObjectForKey:(NUBellBall)aKey;

@end
