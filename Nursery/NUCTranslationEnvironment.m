//
//  NUTranslationEnvironment.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import "NUCTranslationEnvironment.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSURL.h>

#import "NUCPreprocesser.h"
#import "NUCSourceFile.h"

@class NUCSourceFile;

@interface NUCTranslationEnvironment (Private)

- (NUCPreprocesser *)preprocesser;

- (NSMutableDictionary *)externalSourceFiles;
- (NSMutableDictionary *)allSourceFiles;

- (void)preprocess;

@end

@implementation NUCTranslationEnvironment

- (instancetype)initWithSourceFileURLs:(NSArray *)aURLs
{
    NSMutableArray *aSourceFiles = [NSMutableArray array];
    
    [aURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull aURL, NSUInteger idx, BOOL * _Nonnull stop) {
        [aSourceFiles addObject:[[[NUCSourceFile alloc] initWithSourceURL:aURL] autorelease]];
    }];
    
    return [self initWithSourceFiles:aSourceFiles];
}

- (instancetype)initWithSourceFiles:(NSArray *)aSourceFiles
{
    if (self = [super init])
    {
        preprocesser = [NUCPreprocesser new];
        sourceFiles = [aSourceFiles mutableCopy];
        externalSourceFiles = [NSMutableArray new];
        allSourceFiles = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [preprocesser release];
    preprocesser = nil;
    [sourceFiles release];
    sourceFiles = nil;
    [externalSourceFiles release];
    externalSourceFiles = nil;
    [allSourceFiles release];
    allSourceFiles = nil;
    
    [super dealloc];
}

- (NSArray *)sourceFiles
{
    return sourceFiles;
}

- (NUCPreprocesser *)preprocesser
{
    return preprocesser;
}

- (void)translate
{
    [self preprocess];
}

- (void)preprocess
{
    [[self sourceFiles] enumerateObjectsUsingBlock:^(id  _Nonnull aSourceFile, NSUInteger idx, BOOL * _Nonnull stop) {
        [[self preprocesser] preprocessSourceFile:aSourceFile];
    }];
}

@end

