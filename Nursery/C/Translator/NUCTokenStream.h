//
//  NUCTokenStream.h
//  Nursery
//
//  Created by akiha on 2025/02/21.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@protocol NUCToken;

@interface NUCTokenStream : NSObject

@property (nonatomic) NSUInteger position;

- (id <NUCToken>)next;

- (BOOL)skipWhitespacesWithoutNewline;

@end

