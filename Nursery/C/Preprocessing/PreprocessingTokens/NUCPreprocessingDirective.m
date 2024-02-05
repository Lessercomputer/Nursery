//
//  NUCPreprocessingDirective.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCPreprocessingDirective.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPpTokens.h"

@implementation NUCPreprocessingDirective

+ (BOOL)readPpTokensUntilNewlineFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLexicalElement **)aPpTokens
{
    NSUInteger aPosition = [aStream position];
    NUCPpTokens *aPpTokensWithoutNewLine = [NUCPpTokens ppTokens];
    
    while ([aStream hasNext] && ![[aStream peekNext] isNewLine])
        [aPpTokensWithoutNewLine add:[aStream next]];
    
    if ([[aStream peekNext] isNewLine])
    {
        if (aPpTokens)
            *aPpTokens = aPpTokensWithoutNewLine;
        
        return YES;
    }
    
    [aStream setPosition:aPosition];
    return NO;
}

- (BOOL)isPpTokens
{
    return [self type] == NUCLexicalElementPpTokensType;
}

- (BOOL)isIfSection
{
    return [self type] == NUCLexicalElementIfSectionType;
}

- (BOOL)isControlLine
{
    return [self type] == NUCLexicalElementControlLineType;
}

- (BOOL)isTextLine
{
    return [self type] == NUCLexicalElementTextLineType;
}

- (BOOL)isNonDirective
{
    return NO;
}

- (BOOL)isDefine
{
    return [self type] == NUCLexicalElementDefineType;
}

- (BOOL)isInclude
{
    return NO;
}

@end
