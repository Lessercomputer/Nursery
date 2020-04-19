//
//  NUTranslationEnvironment.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSArray, NSMutableArray, NSMutableDictionary, NUCPreprocesser;

@interface NUCTranslationEnvironment : NSObject
{
    NUCPreprocesser *preprocesser;
    NSArray *sourceFiles;
    NSMutableArray *externalSourceFiles;
    NSMutableDictionary *allSourceFiles;
}

- (instancetype)initWithSourceFileURLs:(NSArray *)aURLs;
- (instancetype)initWithSourceFiles:(NSArray *)aSourceFiles;

- (NSArray *)sourceFiles;

- (void)translate;

@end
