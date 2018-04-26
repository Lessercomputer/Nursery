//
//  NUQueue.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/11/27.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

#import "NUTypes.h"

@interface NUQueue : NSObject
{
    id *objects;
    NUUInt64 objectsSize;
    NUUInt64 count;
    NUUInt64 topIndex;
    NUUInt64 bottomIndex;
}

+ (instancetype)queue;

- (void)push:(id)anObject;
- (id)pop;

- (NUUInt64)count;

@end
