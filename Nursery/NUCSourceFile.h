//
//  NUSourceFile.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSURL, NSString, NSMutableString, NSMutableArray, NULibrary;

@interface NUCSourceFile : NSObject
{
    NSURL *url;
    NSString *physicalSourceString;
    NSString *logicalSourcePhase1String;
    NSString *logicalSourcePhase2String;
    NSMutableString *logicalSourceString;
    NULibrary *rangeMappingForPhase1StringToPhysicalString;
    NULibrary *rangeMappingForPhase2StringToPhase1String;
}

- (instancetype)initWithSourceURL:(NSURL *)aURL;
- (instancetype)initWithSourceString:(NSString *)aString url:(NSURL *)aURL;

- (NSString *)physicalSourceString;
- (NSString *)logicalSourceString;

- (void)setLogicalSourceString:(NSString *)aString;

@end
