//
//  NUCoding.h
//  Nursery
//
//  Created by Akifumi Takata on 11/03/13.
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

- (NUUInt64)indexedIvarsSize;

@end
