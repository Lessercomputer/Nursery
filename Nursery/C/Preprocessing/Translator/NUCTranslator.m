//
//  NUCTranslator.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//

#import "NUCTranslator.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSURL.h>

#import "NUCPreprocessor.h"
#import "NUCSourceFile.h"

@class NUCSourceFile;

@interface NUCTranslator (Private)

- (NSMutableDictionary *)externalSourceFiles;
- (NSMutableDictionary *)allSourceFiles;

- (void)preprocess;

@end

@implementation NUCTranslator

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
        sourceFiles = [aSourceFiles mutableCopy];
        externalSourceFiles = [NSMutableArray new];
        allSourceFiles = [NSMutableDictionary new];
        preprocessedSourceFiles = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [sourceFiles release];
    sourceFiles = nil;
    [externalSourceFiles release];
    externalSourceFiles = nil;
    [allSourceFiles release];
    allSourceFiles = nil;
    [preprocessedSourceFiles  release];
    preprocessedSourceFiles = nil;
    
    [super dealloc];
}

- (NSMutableArray *)sourceFiles
{
    return sourceFiles;
}

- (NSMutableArray *)preprocessedSourceFiles
{
    return preprocessedSourceFiles;
}

- (void)translate
{
    [self preprocess];
}

- (void)preprocess
{
    NUCSourceFile *aSourceFile = nil;
    
    while ((aSourceFile = [[self sourceFiles] firstObject]))
    {
        NUCPreprocessor *aPreprocessor = [[NUCPreprocessor alloc] initWithTranslator:self];

        [aPreprocessor preprocessSourceFile:aSourceFile];
        [preprocessedSourceFiles addObject:aSourceFile];
        
        [[self sourceFiles] removeObjectAtIndex:0];
        [aPreprocessor release];
    };
}

@end

