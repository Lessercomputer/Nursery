//
//  NUObjectWrapper.m
//  Nursery
//
//  Created by Akifumi Takata on 11/05/30.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSString.h>

#import "NUObjectWrapper.h"


@implementation NUObjectWrapper

+ (id)objectWrapperWithObject:(id)anObject
{
	return [[[self alloc] initWithObject:anObject] autorelease];
}

- (id)initWithObject:(id)anObject
{
	if (self = [super init])
    {
        [self setObject:anObject];
    }
    
	return self;
}

- (id)object
{
	return object;
}

- (void)setObject:(id)anObject
{
    objectPointer = (NSUInteger)anObject;
	object = anObject;
}

- (NSUInteger)hash
{
	return objectPointer;
}

- (BOOL)isEqual:(id)anObject
{
	if (![anObject isKindOfClass:[NUObjectWrapper class]]) return NO;
	
	return [self isEqualToObjectWrapper:anObject];
}

- (BOOL)isEqualToObjectWrapper:(NUObjectWrapper *)anObjectWrapper
{
	return [self object] == [anObjectWrapper object];
}

- (id)copyWithZone:(NSZone *)zone
{
	return [self retain];
}

- (NSString *)description
{
	return [NSString stringWithFormat:
				@"<%@:%p>object: %@", NSStringFromClass([self class]), self, [self object]];
}

@end
