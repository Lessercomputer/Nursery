//
//  NULazyMutableArray.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/05/22.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSArray.h>
#import <Nursery/NUTypes.h>
#import <Nursery/NUCoding.h>

@interface NULazyMutableArray : NSMutableArray <NUIndexedCoding>
{
    NUUInt64 *oops;
    id *objects;
    NSUInteger capacity;
    NSUInteger count;
}

@property (nonatomic, assign) NUBell *bell;

@end
