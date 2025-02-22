//
//  NUCTokenStream.m
//  Nursery
//
//  Created by akiha on 2025/02/21.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCTokenStream.h"

@implementation NUCTokenStream

- (id <NUCToken>)next
{
    return nil;
}

- (id <NUCToken>)peekNext
{
    return nil;
}

- (BOOL)skipWhitespacesWithoutNewline
{
    return YES;
}

- (BOOL)isForPreprocessing
{
    return NO;
}

@end
