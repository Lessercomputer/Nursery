//
//  NUSourceFile.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSURL, NSString, NSMutableString, NSMutableArray;

@interface NUCSourceFile : NSObject
{
    NSURL *url;
    NSString *physicalSourceString;
    NSMutableString *logicalSourceString;
    NSMutableArray *logicalSourceLines;
}

- (instancetype)initWithSourceURL:(NSURL *)aURL;
- (instancetype)initWithSourceString:(NSString *)aString url:(NSURL *)aURL;

- (NSString *)physicalSourceString;
- (NSString *)logicalSourceString;

- (void)setLogicalSourceString:(NSString *)aString;

@end
