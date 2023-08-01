//
//  NUSourceFile.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSURL, NSString, NSMutableArray, NULibrary, NUCPreprocessingFile;

@interface NUCSourceFile : NSObject
{
    NSURL *url;
    NSString *physicalSourceString;
    NSString *logicalSourcePhase1String;
    NSString *logicalSourceString;
    NULibrary *rangeMappingOfPhase1StringToPhysicalString;
    NULibrary *rangeMappingOfPhase2StringToPhase1String;
    NUCPreprocessingFile *preprocessingFile;
}

- (instancetype)initWithSourceURL:(NSURL *)aURL;
- (instancetype)initWithSourceString:(NSString *)aString url:(NSURL *)aURL;

- (void)preprocessFromPhase1ToPhase2;

- (NSString *)physicalSourceString;
- (NSString *)logicalSourceString;

- (void)setLogicalSourceString:(NSString *)aString;

- (NUCPreprocessingFile *)preprocessingFile;
- (void)setPreprocessingFile:(NUCPreprocessingFile *)aPreprocessingFile;

@end
