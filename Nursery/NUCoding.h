//
//  NUCoding.h
//  Nursery
//
//  Created by P,T,A on 11/03/13.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@class NUAliaser, NUBell;

@protocol NUCoding

- (void)encodeWithAliaser:(NUAliaser *)anAliaser;

- (id)initWithAliaser:(NUAliaser *)anAliaser;

- (NUBell *)bell;
- (void)setBell:(NUBell *)aBell;

@end

@protocol NUIndexedCoding <NUCoding>

- (void)encodeIndexedIvarsWithAliaser:(NUAliaser *)anAliaser;

- (NUUInt64)indexedIvarsSize;

@end
