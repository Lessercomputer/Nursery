//
//  NUCTranslator.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//

#import <Foundation/NSObject.h>

@class NSArray, NSMutableArray, NSMutableDictionary, NUCPreprocessor;

@interface NUCTranslator : NSObject
{
    NSMutableArray *sourceFiles;
    NSMutableArray *externalSourceFiles;
    NSMutableDictionary *allSourceFiles;
    NSMutableArray *preprocessedSourceFiles;
}

- (instancetype)initWithSourceFileURLs:(NSArray *)aURLs;
- (instancetype)initWithSourceFiles:(NSArray *)aSourceFiles;

- (NSMutableArray *)sourceFiles;
- (NSMutableArray *)preprocessedSourceFiles;

- (void)translate;

@end
