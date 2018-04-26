//
//  NUObjectWrapper.h
//  Nursery
//
//  Created by Akifumi Takata on 11/05/30.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@interface NUObjectWrapper : NSObject <NSCopying>
{
    NSUInteger objectPointer;
	id object;
}

+ (id)objectWrapperWithObject:(id)anObject;

- (id)initWithObject:(id)anObject;

- (id)object;
- (void)setObject:(id)anObject;

- (BOOL)isEqualToObjectWrapper:(NUObjectWrapper *)anObjectWrapper;

@end
