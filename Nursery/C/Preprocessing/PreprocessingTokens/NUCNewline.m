//
//  NUCNewline.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCNewline.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSString.h>

@implementation NUCNewline

+ (BOOL)newlineFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCNewline **)aNewline
{
    NSUInteger aPosition = [aStream position];
    NUCDecomposedPreprocessingToken *aToken = [aStream next];
    NUCDecomposedPreprocessingToken *aCr = nil;
    NUCDecomposedPreprocessingToken *anLf = nil;
    
    if (aToken)
    {
        if ([[aToken content] isEqualToString:NUCCR])
        {
            aCr = aToken;
            aToken = [aStream next];
            
            if (aToken && [[aToken content] isEqualToString:NUCLF])
                anLf = aToken;
            else
                [aStream setPosition:aPosition];
        }
        else if ([[aToken content] isEqualToString:NUCLF])
        {
            anLf = aToken;
        }
        else
        {
            [aStream setPosition:aPosition];
            
            return NO;
        }
        
        if (aNewline)
            *aNewline = [NUCNewline newlineWithCr:aCr lf:anLf];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)newlineWithCr:(NUCLexicalElement *)aCr lf:(NUCLexicalElement *)anLf
{
    return [[[self alloc] initWithCr:aCr lf:anLf] autorelease];
}

- (instancetype)initWithCr:(NUCLexicalElement *)aCr lf:(NUCLexicalElement *)anLf
{
    if (self = [super initWithType:NUCLexicalElementNewlineType])
    {
        cr = [aCr retain];
        lf = [anLf retain];
    }
    
    return self;
}

- (void)dealloc
{
    [cr release];
    [lf release];
    
    [super dealloc];
}

- (BOOL)isCr
{
    return [self cr] && ![self lf];
}

- (BOOL)isLf
{
    return ![self cr] && [self lf];
}

- (BOOL)isCrLf
{
    return [self cr] && [self lf];
}

- (NUCLexicalElement *)cr
{
    return cr;
}

- (NUCLexicalElement *)lf
{
    return lf;
}

- (BOOL)isWhitespace
{
    return YES;
}

@end
