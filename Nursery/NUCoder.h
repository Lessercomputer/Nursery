//
//  NUCoder.h
//  Nursery
//
//  Created by Akifumi Takata on 11/03/20.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

@class NUAliaser;


@interface NUCoder : NSObject
{

}

+ (id)coder;

- (id)new;

- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser;
- (void)encodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser;

- (void)decode:(id)anObject withAliaser:(NUAliaser *)anAliaser;
- (void)decodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser;

- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser;

- (BOOL)canMoveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser;

- (void)moveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser;

@end
