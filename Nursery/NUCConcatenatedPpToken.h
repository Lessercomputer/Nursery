//
//  NUCConcatenatedPpToken.h
//  Nursery
//
//  Created by aki on 2023/06/09.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCDecomposedPreprocessingToken.h"


@interface NUCConcatenatedPpToken : NUCDecomposedPreprocessingToken
{
    NUCDecomposedPreprocessingToken *leftToken;
    NUCDecomposedPreprocessingToken *rightToken;
}

- (instancetype)initWithLeft:(NUCDecomposedPreprocessingToken *)aLeftToken right:(NUCDecomposedPreprocessingToken *)aRightToken;

- (NUCDecomposedPreprocessingToken *)leftToken;
- (NUCDecomposedPreprocessingToken *)rightToken;

@end

