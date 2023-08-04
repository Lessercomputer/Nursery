//
//  NUCConcatenatedPpToken.m
//  Nursery
//
//  Created by aki on 2023/06/09.
//

#import "NUCConcatenatedPpToken.h"
#import "NUCDecomposer.h"
#import <Foundation/NSString.h>

@implementation NUCConcatenatedPpToken

+ (instancetype)concatenatedPpTokenWithLeft:(NUCDecomposedPreprocessingToken *)aLeftToken right:(NUCDecomposedPreprocessingToken *)aRightToken
{
    return [[[self alloc] initWithLeft:aLeftToken right:aRightToken] autorelease];
}

- (instancetype)initWithLeft:(NUCDecomposedPreprocessingToken *)aLeftToken right:(NUCDecomposedPreprocessingToken *)aRightToken
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        leftToken = [aLeftToken retain];
        rightToken = [aRightToken retain];
    }
    
    return self;
}

- (void)dealloc
{
    [leftToken release];
    [rightToken release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)leftToken
{
    return leftToken;
}

- (NUCDecomposedPreprocessingToken *)rightToken
{
    return rightToken;
}

- (NSString *)string
{
    NSMutableString *aString = [NSMutableString string];
    [self addStringTo:aString];
    
    return aString;
}

- (void)addStringTo:(NSMutableString *)aString
{
    [[self leftToken] addStringTo:aString];
    [[self rightToken] addStringTo:aString];
}

- (BOOL)isValid
{
    NSArray *aTokens = [[[NUCDecomposer new] autorelease] decomposePreprocessingTokensIn:[self string]];
    return [aTokens count] == 1;
}

@end
