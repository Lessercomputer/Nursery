//
//  NUCControlLineInclude.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/10.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLineInclude.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPpTokens.h"
#import "NUCNewline.h"
#import "NUCPreprocessor.h"

#import <Foundation/NSString.h>

@implementation NUCControlLineInclude

+ (BOOL)controlLineIncludeFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken
{
    [aStream skipWhitespacesWithoutNewline];
    
    if ([[aDirectiveName content] isEqualToString:NUCPreprocessingDirectiveInclude])
    {
        NUCPpTokens *aPpTokens = nil;
        NUCNewline *aNewLine = nil;
        
        if ([NUCPpTokens ppTokensFrom:aStream into:&aPpTokens] && [aPpTokens isPpTokens])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            if ([NUCNewline newlineFrom:aStream into:&aNewLine])
            {
                if (aToken)
                    *aToken = [NUCControlLineInclude includeWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewLine];
                
                return YES;
            }
        }
    }
    
    return NO;
}

+ (instancetype)includeWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementControlLineType hash:aHash directiveName:aDirectiveName newline:aNewline])
    {
        ppTokens = [aPpTokens retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    [aPreprocessor include:self];
}

@end
