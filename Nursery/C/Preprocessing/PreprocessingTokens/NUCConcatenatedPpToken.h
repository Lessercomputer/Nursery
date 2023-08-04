//
//  NUCConcatenatedPpToken.h
//  Nursery
//
//  Created by aki on 2023/06/09.
//

#import "NUCDecomposedPreprocessingToken.h"


@interface NUCConcatenatedPpToken : NUCDecomposedPreprocessingToken
{
    NUCDecomposedPreprocessingToken *leftToken;
    NUCDecomposedPreprocessingToken *rightToken;
}

+ (instancetype)concatenatedPpTokenWithLeft:(NUCDecomposedPreprocessingToken *)aLeftToken right:(NUCDecomposedPreprocessingToken *)aRightToken;

- (instancetype)initWithLeft:(NUCDecomposedPreprocessingToken *)aLeftToken right:(NUCDecomposedPreprocessingToken *)aRightToken;

- (NUCDecomposedPreprocessingToken *)leftToken;
- (NUCDecomposedPreprocessingToken *)rightToken;

- (BOOL)isValid;

@end

