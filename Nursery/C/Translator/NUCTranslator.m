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
#import "NUCPreprocessingFile.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCToken.h"
#import "NUCTranslationUnit.h"


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
        _translationUnits = [NSMutableArray new];
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

- (NUCSourceFile *)sourceFileFor:(NSString *)aFilename
{
    __block NUCSourceFile *aSouceFile = nil;
    
    [[self searchPathURLs] enumerateObjectsUsingBlock:^(NSURL * _Nonnull aSearchPathURL, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *aSourceFileURL = [aSearchPathURL URLByAppendingPathComponent:aFilename];
        aSouceFile = [[NUCSourceFile alloc] initWithSourceURL:aSourceFileURL];
        if (aSouceFile)
            *stop = YES;
    }];
    
    return [aSouceFile autorelease];
}

- (NSMutableArray *)preprocessedSourceFiles
{
    return preprocessedSourceFiles;
}

- (void)translate
{
    [self preprocess];
    
    [[self preprocessedSourceFiles] enumerateObjectsUsingBlock:^(NUCSourceFile * _Nonnull aPreprocessedSourceFile, NSUInteger idx, BOOL * _Nonnull aStop) {
        
        NSArray *aPpTokens = [[aPreprocessedSourceFile preprocessingFile] macroReplacedPpTokens];
        NUCPreprocessingTokenToTokenStream *aPpTokenToTokenStream = [[[NUCPreprocessingTokenToTokenStream alloc] initWithPreprocessingTokens:aPpTokens] autorelease];
        
        NUCToken *aToken = nil;
        
        while ((aToken = [aPpTokenToTokenStream next]))
        {
            NSLog(@"%@", aToken);
        }
        
        [aPpTokenToTokenStream setPosition:0];
        
        NUCTranslationUnit *aTranslationUnit = nil;
        if ([NUCTranslationUnit translationUnitFrom:aPpTokenToTokenStream into:&aTranslationUnit])
            [[self translationUnits] addObject:aTranslationUnit];
        else
            *aStop = YES;
    }];
}

- (void)preprocess
{
    NUCSourceFile *aSourceFile = nil;
    
    while ((aSourceFile = [[self sourceFiles] firstObject]))
    {
        NUCPreprocessor *aPreprocessor = [[NUCPreprocessor alloc] initWithTranslator:self];

        [aPreprocessor preprocessSourceFile:aSourceFile];
        [preprocessedSourceFiles addObject:aSourceFile];
        
        NSLog(@"%@", [[aSourceFile preprocessingFile] preprocessedStringWithPreprocessor:aPreprocessor]);
        
        [[self sourceFiles] removeObjectAtIndex:0];
        [aPreprocessor release];
    };
}

@end

