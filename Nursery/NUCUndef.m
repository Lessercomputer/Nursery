//
//  NUCUndef.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/11/18.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCUndef.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCNewline.h"

@implementation NUCUndef

+ (BOOL)undefFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken
{
    if ([aDirectiveName isUndef])
    {
        NSUInteger aPosition = [aStream position];
        
        [aStream skipWhitespacesWithoutNewline];
        
        NUCDecomposedPreprocessingToken *anIdentifier = [aStream next];
        NUCNewline *aNewline = nil;

        if ([anIdentifier isIdentifier])
        {
            [aStream skipWhitespacesWithoutNewline];
                        
            if (anIdentifier && [NUCNewline newlineFrom:aStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCUndef undefWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier newline:aNewline];
                
                return YES;
            }
        }
        
        [aStream setPosition:aPosition];
    }
    
    return NO;
}

+ (instancetype)undefWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCPreprocessingToken *)anIdentifier newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCPreprocessingToken *)anIdentifier newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementUndefType hash:aHash directiveName:aDirectiveName newline:aNewline])
    {
        identifier = [anIdentifier retain];
    }
    
    return self;
}

- (void)dealloc
{
    [identifier release];
    
    [super dealloc];
}

- (NUCPreprocessingToken *)identifier
{
    return identifier;
}

@end
