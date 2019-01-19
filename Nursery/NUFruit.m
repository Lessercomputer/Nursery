//
//  NUFruit.m
//  Nursery
//
//  Created by Akifumi Takata on 2019/01/16.
//  Copyright © 2019年 Nursery-Framework. All rights reserved.
//

#import "NUFruit.h"

@implementation NUFruit

+ (id)Fruit
{
    return [self fruit];
}

+ (id)fruit
{
    return [[self new] autorelease];
}

- (id)Fruit
{
    return self;
}

- (id)fruit
{
    return self;
}

- (id)is
{
    return [NUIs is];
}

- (id)a
{
    return [NUA a];
}

- (id)do
{
    return [NUDo do];
}

- (id)serially
{
    return [NUSerially serially];
}

@end

@implementation NUIs

+ (id)Is
{
    return [self is];
}

+ (id)is
{
    return [[self new] autorelease];
}

- (id)Is
{
    return self;
}

- (id)is
{
    return self;
}

@end

@implementation NUA

+ (id)A
{
    return [self a];
}

+ (id)a
{
    return [[self new] autorelease];
}

- (id)A
{
    return self;
}

- (id)a
{
    return self;
}

@end

@implementation NUThen

+ (id)Then
{
    return [self then];
}

+ (id)then
{
    return [[self new] autorelease];
}

- (id)Then
{
    return self;
}

- (id)then
{
    return self;
}

@end

@implementation NUNo

+ (id)No
{
    return [self no];
}

+ (id)no
{
    return [[self new] autorelease];
}

- (id)No
{
    return self;
}

- (id)no
{
    return self;
}

@end

@implementation NUDo

+ (id)Do
{
    return [self do];
}

+ (id)do
{
    return [[self new] autorelease];
}

- (id)Do
{
    return self;
}

- (id)do
{
    return self;
}

@end

@implementation NUSerially

+ (id)serially
{
    return [[self new] autorelease];
}

- (id)Serially
{
    return self;
}

- (id)serially
{
    return self;
}

@end

