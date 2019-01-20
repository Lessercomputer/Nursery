//
//  NUFruit.m
//  Nursery
//
//  Created by Akifumi Takata on 2019/01/16.
//  Copyright © 2019年 Nursery-Framework. All rights reserved.
//

#import "NUFruit.h"

@implementation NUFruit

+ (instancetype)fruit
{
    return [[self alloc] autorelease];
}

+ (instancetype)fruitWithDescription:(NSString *)aString
{
    return [[self alloc] initWithDescription:aString];
}

- (instancetype)initWithDescription:(NSString *)aString
{
    return nil;
}

- (instancetype)do
{
    return self;
}

- (instancetype)serially
{
    return self;
}

- (instancetype)parallelly
{
    return self;
}

@end
