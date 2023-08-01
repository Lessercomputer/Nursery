//
//  NUCNonDirective.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCNonDirective.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPpTokens.h"
#import "NUCNewline.h"

@implementation NUCNonDirective

+ (BOOL)hashAndNonDirectiveFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingDirective **)aToken
{
    NSUInteger aPosition = [aStream position];
    NUCDecomposedPreprocessingToken *aPpToken = [aStream next];
    
    if ([aPpToken isHash])
    {
        NUCNonDirective *aNonDirective = nil;

        [aStream skipWhitespacesWithoutNewline];
    
        if ([self nonDirectiveFrom:aStream into:&aNonDirective hash:aPpToken])
        {
            if (aToken)
                *aToken = aNonDirective;
            
            return YES;
        }
    }
    
    [aStream setPosition:aPosition];
    
    return NO;
}

+ (BOOL)nonDirectiveFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCNonDirective **)aToken hash:(NUCDecomposedPreprocessingToken *)aHash
{
    NUCPpTokens *aPpTokens = [NUCPpTokens ppTokens];
    NUCNewline *aNewline = nil;
    
    if ([[aPreprocessingTokenStream peekNext] isDirectiveName])
        return NO;
    
    if ([NUCPpTokens ppTokensFrom:aPreprocessingTokenStream into:&aPpTokens] && [NUCNewline newlineFrom:aPreprocessingTokenStream into:&aNewline])
    {
        if (aToken)
            *aToken = [NUCNonDirective noneDirectiveWithHash:aHash ppTokens:aPpTokens newline:aNewline];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)noneDirectiveWithHash:(NUCDecomposedPreprocessingToken *)aHash ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash ppTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithPpTokens:aPpTokens newline:aNewline])
    {
        hash = [aHash retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    
    [super dealloc];
}

@end
