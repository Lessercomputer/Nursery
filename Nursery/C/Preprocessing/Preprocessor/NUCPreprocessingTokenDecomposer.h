//
//  NUCPreprocessingTokenDecomposer.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/05/15.
//

#import <Foundation/NSObject.h>

@class NUCSourceFile;
@class NSArray, NSScanner;

@interface NUCPreprocessingTokenDecomposer : NSObject
{
    BOOL hashExistsOnCurrentLine;
    BOOL includeExistsOnCurrentLine;
}

+ (instancetype)decomposer;

+ (BOOL)scanDigitSequenceFrom:(NSScanner *)aScanner into:(NSString **)aString;
+ (BOOL)scanSCharSequenceFrom:(NSScanner *)aScanner into:(NSString **)aString;

- (NSArray *)decomposePreprocessingFile:(NUCSourceFile *)aSourceFile;
- (NSArray *)decomposePreprocessingTokensIn:(NSString *)aString;

@end

