//
//  NUQueueWithDepth.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/05/21.
//

#import "NUQueue.h"
#import "NUTypes.h"

@interface NUQueueWithDepth : NUQueue

@property (nonatomic) NUUInt64 depth;

@end
