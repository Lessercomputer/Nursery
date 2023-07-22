//
//  NUCConcatenatedPpToken.m
//  Nursery
//
//  Created by aki on 2023/06/09.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCConcatenatedPpToken.h"

@implementation NUCConcatenatedPpToken

+ (instancetype)concatenatedPpTokenWithLeft:(NUCDecomposedPreprocessingToken *)aLeftToken right:(NUCDecomposedPreprocessingToken *)aRightToken
{
    return [[[self alloc] initWithLeft:aLeftToken right:aRightToken] autorelease];
}

- (instancetype)initWithLeft:(NUCDecomposedPreprocessingToken *)aLeftToken right:(NUCDecomposedPreprocessingToken *)aRightToken
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        leftToken = aLeftToken;
        rightToken = aRightToken;
    }
    
    return self;
}

- (NUCDecomposedPreprocessingToken *)leftToken
{
    return leftToken;
}

- (NUCDecomposedPreprocessingToken *)rightToken
{
    return rightToken;
}

@end
