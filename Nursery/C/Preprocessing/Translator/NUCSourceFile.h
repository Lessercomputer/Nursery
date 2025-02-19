//
//  NUSourceFile.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//

#import <Foundation/NSObject.h>

@class NSURL, NSString, NSMutableArray;
@class NULibrary, NUCPreprocessingFile, NUCLine, NUCError;

@interface NUCSourceFile : NSObject
{
    NSString *physicalSourceString;
    NSString *logicalSourcePhase1String;
    NSString *logicalSourceString;
    NULibrary *rangeMappingOfPhase1StringToPhysicalString;
    NULibrary *lineRangeMappingOfPhase2StringToPhase1String;
    NUCPreprocessingFile *preprocessingFile;
}

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSArray *lineRanges;
@property (nonatomic, copy, readonly) NSString *preprocessedString;

- (instancetype)initWithSourceURL:(NSURL *)aURL;
- (instancetype)initWithSourceString:(NSString *)aString url:(NSURL *)aURL;

- (void)preprocessFromPhase1ToPhase2;

- (NSString *)physicalSourceString;
- (NSString *)logicalSourceString;

- (void)setLogicalSourceString:(NSString *)aString;

- (NSUInteger)lineNumberForLocation:(NSUInteger)aLocation;

@property (nonatomic, readonly) NSUInteger lineCount;

@property (nonatomic) NSUInteger lineNumberBeforeAdjustment;
@property (nonatomic) NSInteger lineNumberAdjustmentOffset;

- (void)line:(NUCLine *)aLine;
- (void)error:(NUCError *)anError;

- (NUCPreprocessingFile *)preprocessingFile;
- (void)setPreprocessingFile:(NUCPreprocessingFile *)aPreprocessingFile;

@property (nonatomic, copy, readonly) NSString *file;
@property (nonatomic, retain) NSMutableArray *errors;

- (void)addError:(NUCError *)anError;

@end
