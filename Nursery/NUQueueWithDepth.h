//
//  NUQueueWithDepth.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/05/21.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUQueue.h"
#import "NUTypes.h"

@interface NUQueueWithDepth : NUQueue

@property (nonatomic) NUUInt64 depth;

@end
