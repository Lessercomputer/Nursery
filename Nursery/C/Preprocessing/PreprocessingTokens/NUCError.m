//
//  NUCError.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2022/03/28.
//

#import "NUCError.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPpTokens.h"
#import "NUCNewline.h"

@implementation NUCError

+ (BOOL)errorFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken
{
    if ([aDirectiveName isError])
    {
        NSUInteger aPosition = [aStream position];
        NUCPpTokens *aPpTokens = nil;
        NUCNewline *aNewline = nil;
        
        if ([NUCPpTokens ppTokensFrom:aStream into:&aPpTokens])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            if ([NUCNewline newlineFrom:aStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCError errorWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline];
                
                return YES;
            }
        }
        
        [aStream setPosition:aPosition];
    }
    
    return NO;
}

+ (instancetype)errorWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementErrorType hash:aHash directiveName:aDirectiveName newline:aNewline])
    {
        ppTokens = [aPpTokens retain];
    }
    
    return self;
}

- (NUCPpTokens *)ppTokens
{
    return ppTokens;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

@end
