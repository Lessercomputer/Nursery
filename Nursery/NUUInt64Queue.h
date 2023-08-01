//
//  NUUInt64Queue.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/17.
//

#import "NUOpaqueQueue.h"

@interface NUUInt64Queue : NUOpaqueQueue

- (void)push:(NUUInt64)aValue;
- (NUUInt64)pop;

@end
