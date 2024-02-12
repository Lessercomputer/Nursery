//
//  NUCLine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2022/03/28.
//

#import "NUCLine.h"
#import "NUCPreprocessor.h"
#import "NUCPpTokens.h"
#import "NUCPreprocessingTokenDecomposer.h"

#import <Foundation/NSScanner.h>

@implementation NUCLine

+ (instancetype)lineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementLineType hash:aHash directiveName:aDirectiveName newline:aNewline])
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

- (NUCPpTokens *)ppTokens
{
    return ppTokens;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    NSString *aPreprocessedString = [NUCPpTokens preprocessedStringFromPpTokens:[self ppTokens] with:aPreprocessor];
    NSScanner *aScanner = [NSScanner scannerWithString:aPreprocessedString];
    [aScanner setCharactersToBeSkipped:nil];
    NSString *aDigitSequence = nil;
    NSString *aSCharSequence = nil;

    if ([NUCPreprocessingTokenDecomposer scanDigitSequenceFrom:aScanner into:&aDigitSequence])
    {
        [self setDigitSequence:aDigitSequence];
        
        [aScanner scanCharactersFromSet:[NUCLexicalElement NUCWhiteSpaceWithoutNewlineCharacterSet] intoString:NULL];
        
        if ([aScanner scanString:NUCDoubleQuotationMark intoString:NULL])
        {
            [NUCPreprocessingTokenDecomposer scanSCharSequenceFrom:aScanner into:&aSCharSequence];
            [self setSCharSequence:aSCharSequence];
            
            if (![aScanner scanString:NUCDoubleQuotationMark intoString:NULL])
                ;
        }
    }
    
    [aPreprocessor line:self];
}

@end
