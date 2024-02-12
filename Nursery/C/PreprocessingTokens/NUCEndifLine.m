//
//  NUCEndifLine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCEndifLine.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCNewline.h"

#import <Foundation/NSString.h>

@implementation NUCEndifLine

+ (BOOL)endifLineFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingDirective **)anEndifLine
{
    NSUInteger aPosition = [aStream position];
    [aStream skipWhitespaces];
    NUCDecomposedPreprocessingToken *aToken = [aStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCDecomposedPreprocessingToken *aHash = aToken;
        NUCDecomposedPreprocessingToken *anEndif = [aStream next];
        
        if (anEndif && [[anEndif content] isEqualToString:NUCPreprocessingDirectiveEndif])
        {
            NUCNewline *aNewline = nil;
            if ([NUCNewline newlineFrom:aStream into:&aNewline])
            {
                if (anEndif)
                    *anEndifLine = [NUCEndifLine endifLineWithHash:aHash endif:anEndif newline:aNewline];
                
                return YES;
            }
        }
    }
    
    [aStream setPosition:aPosition];
    
    return NO;
}

+ (instancetype)endifLineWithHash:(NUCDecomposedPreprocessingToken *)aHash endif:(NUCDecomposedPreprocessingToken *)anEndif newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash endif:anEndif newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash endif:(NUCDecomposedPreprocessingToken *)anEndif newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementEndifLineType])
    {
        hash = [aHash retain];
        endif = [anEndif retain];
        newline = [aNewline retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    [endif release];
    [newline release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)hash
{
    return hash;
}

- (NUCDecomposedPreprocessingToken *)endif
{
    return endif;
}

- (NUCNewline *)newline
{
    return newline;
}

@end
