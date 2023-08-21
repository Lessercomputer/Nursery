//
//  NUCUndef.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/11/18.
//

#import "NUCUndef.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCNewline.h"
#import "NUCPreprocessor.h"

#import <Foundation/NSString.h>

@implementation NUCUndef

+ (BOOL)undefFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken
{
    if (![[aDirectiveName content] isEqualToString:NUCPreprocessingDirectiveUndef])
        return NO;
    
    NSUInteger aPosition = [aStream position];
    
    [aStream skipWhitespacesWithoutNewline];
    
    NUCDecomposedPreprocessingToken *anIdentifierOrNot = [aStream next];
    NUCNewline *aNewline = nil;

    if ([anIdentifierOrNot isIdentifier])
    {
        [aStream skipWhitespacesWithoutNewline];
                    
        if (anIdentifierOrNot && [NUCNewline newlineFrom:aStream into:&aNewline])
        {
            if (aToken)
                *aToken = [NUCUndef undefWithHash:aHash directiveName:aDirectiveName identifier:(NUCIdentifier *)anIdentifierOrNot newline:aNewline];
            
            return YES;
        }
    }
    
    [aStream setPosition:aPosition];
    
    return NO;
}

+ (instancetype)undefWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCIdentifier *)anIdentifier newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCIdentifier *)anIdentifier newline:(NUCNewline *)aNewline
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

- (NUCIdentifier *)identifier
{
    return identifier;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    [aPreprocessor undef:self];
}

@end
