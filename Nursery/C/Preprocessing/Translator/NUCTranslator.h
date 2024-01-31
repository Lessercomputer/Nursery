//
//  NUCTranslator.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//

#import <Foundation/NSObject.h>

@class NSArray, NSMutableArray, NSMutableDictionary, NUCPreprocessor, NUCSourceFile;

@interface NUCTranslator : NSObject
{
    NSMutableArray *sourceFiles;
    NSMutableArray *externalSourceFiles;
    NSMutableDictionary *allSourceFiles;
    NSMutableArray *preprocessedSourceFiles;
}

@property (nonatomic, retain) NSMutableArray *searchPathURLs;

- (instancetype)initWithSourceFileURLs:(NSArray *)aURLs;
- (instancetype)initWithSourceFiles:(NSArray *)aSourceFiles;

- (NSMutableArray *)sourceFiles;
- (NUCSourceFile *)sourceFileFor:(NSString *)aFilename;

- (NSMutableArray *)preprocessedSourceFiles;

- (void)translate;

@end
