//
//  NUCTextLine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCTextLine.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPpTokens.h"
#import "NUCNewline.h"
#import "NUCPreprocessor.h"

@implementation NUCTextLine

+ (BOOL)textLineFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingDirective **)aToken
{
    if ([[aStream peekNext] isHash])
        return NO;
    
    NSUInteger aPosition = [aStream position];
    NUCPpTokens *aPpTokens = nil;
    NUCNewline *aNewline = nil;
    
    [NUCPpTokens ppTokensFrom:aStream into:&aPpTokens];
    [aStream skipWhitespacesWithoutNewline];
    
    if ([NUCNewline newlineFrom:aStream into:&aNewline])
    {
        if (aToken)
            *aToken = [NUCTextLine textLineWithPpTokens:aPpTokens newline:aNewline];
        
        return YES;
    }
    
    [aStream setPosition:aPosition];
    
    return NO;
}

+ (instancetype)textLineWithPpTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithPpTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithPpTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementTextLineType])
    {
        ppTokens = [aPpTokens retain];
        newline = [aNewline retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    [newline release];
    
    [super dealloc];
}

- (NUCPpTokens *)ppTokens
{
    return ppTokens;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    [self setMacroExpandedPpTokens:[aPreprocessor preprocessPpTokens:[self ppTokens]]];
}

@end
