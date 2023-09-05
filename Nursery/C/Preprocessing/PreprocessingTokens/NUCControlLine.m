//
//  NUCControlLine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//

#import "NUCControlLine.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCLine.h"
#import "NUCError.h"
#import "NUCPragma.h"
#import "NUCControlLineInclude.h"
#import "NUCControlLineDefine.h"
#import "NUCUndef.h"
#import "NUCPpTokens.h"
#import "NUCNewline.h"
#import "NUCPreprocessor.h"
#import <Foundation/NSString.h>

@implementation NUCControlLine

+ (BOOL)controlLineFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCPreprocessingDirective **)aToken
{
    NSUInteger aPosition = [aStream position];
    NUCDecomposedPreprocessingToken *aHash = [aStream next];
    
    if (aHash && [aHash isHash])
    {
        [aStream skipWhitespacesWithoutNewline];
        
        NUCDecomposedPreprocessingToken *aDirectiveName = [aStream next];
        
        if (aDirectiveName)
        {
            if ([NUCControlLineInclude controlLineIncludeFrom:aStream hash:aHash directiveName:aDirectiveName into:aToken])
                return YES;
            else if ([NUCControlLineDefine controlLineDefineFrom:aStream with:aPreprocessor isSkipped:aGroupIsSkipped hash:aHash directiveName:aDirectiveName into:aToken])
                return YES;
            else if ([NUCUndef undefFrom:aStream hash:aHash directiveName:aDirectiveName into:aToken])
                return YES;
            else if ([self controlLineLineFrom:aStream hash:aHash directiveName:aDirectiveName into:(NUCLine **)aToken])
                return YES;
            else if ([NUCError errorFrom:aStream hash:aHash directiveName:aDirectiveName into:(NUCError **)aToken])
                return YES;
            else if ([NUCPragma pragmaFrom:aStream hash:aHash directiveName:aDirectiveName into:(NUCPragma **)aToken])
                return YES;
        }
        else
        {
            if ([self controlLineNewlineFrom:aStream hash:aHash directiveName:aDirectiveName into:(NUCControlLine **)aToken])
                return YES;
        }
    }
    
    [aStream setPosition:aPosition];
    
    return NO;
}

+ (BOOL)controlLineLineFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCLine **)aToken
{
    if ([[aDirectiveName content] isEqualToString:NUCPreprocessingDirectiveLine])
    {
        NSUInteger aPosition = [aStream position];
        NUCPpTokens *aTokens = nil;
        NUCNewline *aNewline = nil;
        
        [aStream skipWhitespacesWithoutNewline];
        
        if ([NUCPpTokens ppTokensFrom:aStream into:&aTokens])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            if ([NUCNewline newlineFrom:aStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCLine lineWithHash:aHash directiveName:aDirectiveName ppTokens:aTokens newline:aNewline];
                
                return YES;
            }
        }
        
        [aStream setPosition:aPosition];
    }
    
    return NO;
}

+ (BOOL)controlLineNewlineFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken
{
    NSUInteger aPosition = [aStream position];
    NUCNewline *aNewline = nil;
    
    [aStream skipWhitespacesWithoutNewline];
    
    if ([NUCNewline newlineFrom:aStream into:&aNewline])
    {
        if (aToken)
            *aToken = [[[NUCControlLine alloc] initWithType:NUCLexicalElementControlLineNewlineType hash:aHash directiveName:aDirectiveName newline:aNewline] autorelease];
        
        return YES;
    }
    
    [aStream setPosition:aPosition];
    
    return NO;
}

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:aType])
    {
        hash = [aHash retain];
        directiveName = [aDirectiveName retain];
        newline = [aNewline retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    [directiveName release];
    [newline release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)hash
{
    return hash;
}

- (NUCDecomposedPreprocessingToken *)directiveName
{
    return directiveName;
}

- (NUCNewline *)newline
{
    return newline;
}

- (BOOL)isControlLine
{
    return YES;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    
}

@end
