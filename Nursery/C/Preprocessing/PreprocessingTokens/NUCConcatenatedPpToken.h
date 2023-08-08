//
//  NUCConcatenatedPpToken.h
//  Nursery
//
//  Created by aki on 2023/06/09.
//

#import "NUCDecomposedPreprocessingToken.h"


@interface NUCConcatenatedPpToken : NUCDecomposedPreprocessingToken
{
    NSArray *ppTokens;
}

+ (instancetype)concatenatedPpTokenWithPpTokens:(NSArray *)aPpTokens;

- (instancetype)initWithPpTokens:(NSArray *)aPpTokens;

- (NSArray *)ppTokens;
- (NUCPreprocessingToken *)concatenatedPpToken;
- (BOOL)isValid;

@end

