//
//  NULinkedListElement.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NULinkedListElement.h"

@implementation NULinkedListElement

+ (instancetype)listElementWithObject:(id)anObject
{
    return [[[self alloc] initWithObject:anObject] autorelease];
}

- (instancetype)initWithObject:(id)anObject
{
    if (self = [super init])
    {
        _object = [anObject retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_object release];
    _object = nil;
    
    [super dealloc];
}

@end
