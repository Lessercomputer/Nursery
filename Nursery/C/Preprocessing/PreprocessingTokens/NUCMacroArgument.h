//
//  NUCMacroArgument.h
//  Nursery
//
//  Created by aki on 2023/08/04.
//

#import "NUCPreprocessingToken.h"

@class NUCDecomposedPreprocessingToken;
@class NSMutableArray, NSMutableString;

@interface NUCMacroArgument : NUCPreprocessingToken
{
    NUCDecomposedPreprocessingToken *precededComma;
    NSMutableArray *argument;
}

+ (instancetype)argument;

- (NUCDecomposedPreprocessingToken *)precededComma;
- (void)setPrecededComma:(NUCDecomposedPreprocessingToken *)aPrecededComma;

- (NSMutableArray *)argument;

- (NSMutableArray *)unexpandedPpTokens;
- (void)addUnexpandedPpTokensTo:(NSMutableArray *)aPpTokens;
- (NSMutableArray *)expandedPpTokens;

- (void)add:(NUCPreprocessingToken *)aPpToken;

- (BOOL)isPlacemaker;

- (NSArray *)ppTokensByTrimingWhitespaces;

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces;

@end
