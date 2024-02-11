//
//  NUCPreprocessingTokenToTokenConverter.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCPreprocessingTokenToTokenConverter.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCToken.h"
#import "NUCKeyword.h"
#import "NUCConstant.h"

#import <Foundation/NSArray.h>

@implementation NUCPreprocessingTokenToTokenConverter

- (instancetype)initWithPreprocessingTokens:(NSArray *)aPreprocessingTokens
{
    self = [super init];
    
    if (self)
    {
        _preprocessingTokens = [aPreprocessingTokens retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_preprocessingTokens release];
    
    [super dealloc];
}

- (id <NUCToken>)next
{
    id <NUCToken> aToken = nil;
    
    aToken = [self basicNext];
    
    return aToken;
}

- (id <NUCToken>)basicNext
{
    NUCDecomposedPreprocessingToken *aPpToken = nil;
    
    while (YES)
    {
        if ([self position] < [[self preprocessingTokens] count])
        {
            NSUInteger aPosition = [self position];
            aPpToken = [[self preprocessingTokens] objectAtIndex:aPosition++];
            
            [self setPosition:aPosition];
            
            if ([aPpToken isIdentifier])
            {
                if ([NUCToken ppTokenIsKeyword:aPpToken])
                    return [NUCKeyword tokenWith:aPpToken];
                else
                    return aPpToken;
            }
            else if ([aPpToken isStringLiteral])
                return aPpToken;
            else if ([aPpToken isPunctuator])
                return aPpToken;
            else if ([aPpToken isPpNumber])
                return [NUCConstant constantFromPpToken:aPpToken];
        }
        else
            return nil;
    }
}

@end
