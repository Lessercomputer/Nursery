//
//  NUCPragmaOperator.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/11/02.
//

#import "NUCPragmaOperator.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCStringLiteral.h"
#import "NUCDecomposer.h"
#import "NUCPragma.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSScanner.h>

@implementation NUCPragmaOperator

+ (NSMutableArray *)executePragmaOperatorsIn:(NSMutableArray *)aPpTokens preprocessor:(NUCPreprocessor *)aPreprocessor
{
    NSMutableArray *aPragmaOperatorExecutedPpTokens = [NSMutableArray array];
    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aStream next];
        
        if ([aPpToken isIdentifier] && [[aPpToken content] isEqual:NUCIdentifierPragmaOperator])
        {
            [aStream skipWhitespaces];
            
            aPpToken = [aStream next];
            
            if (aPpToken && [aPpToken isOpeningParenthesis])
            {
                [aStream skipWhitespaces];
                
                aPpToken = [aStream next];
                
                if (aPpToken && [aPpToken isStringLiteral])
                {
                    NUCStringLiteral *aStringLiteral = (NUCStringLiteral *)aPpToken;
                    
                    [aStream skipWhitespaces];
                    aPpToken = [aStream next];
                    
                    if (aPpToken && [aPpToken isClosingParenthesis])
                    {
                        [self executePragmaOperatorOperand:aStringLiteral preprocessor:aPreprocessor];
                    }
                }
            }
        }
        else
            [aPragmaOperatorExecutedPpTokens addObject:aPpToken];
    }
    
    return aPragmaOperatorExecutedPpTokens;
}

+ (NSMutableArray *)executePragmaOperatorOperand:(NUCStringLiteral *)aStringLiteral preprocessor:(NUCPreprocessor *)aPreprocessor
{
    NSMutableArray *aPpTokens = [NSMutableArray array];
    NUCDecomposer *aDecomposer = [NUCDecomposer decomposer];
    NSArray *aDecomposedPpTokens = [aDecomposer decomposePreprocessingTokensIn:[self destringizeStringLiteral:aStringLiteral]];
    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aDecomposedPpTokens];
    NUCControlLine *aPragma = nil;
    
    if ([NUCPragma pragmaFromPragmaOperator:aStream into:&aPragma])
        [aPragma preprocessWith:aPreprocessor];
    
    return aPpTokens;
}

+ (NSMutableString *)destringizeStringLiteral:(NUCStringLiteral *)aStringLiteral
{
    NSString *aStringToDestringize = [aStringLiteral content];
    NSMutableString *aString = [NSMutableString string];
    NSScanner *aScanner = [NSScanner scannerWithString:aStringToDestringize];
    [aScanner setCharactersToBeSkipped:nil];
    
    while (![aScanner isAtEnd])
    {
        NSString *aSubstring = nil;
        
        if ([aScanner scanUpToString:NUCBackslash intoString:&aSubstring])
            [aString appendString:aSubstring];
        
        if ([aScanner scanString:NUCBackslash intoString:nil])
        {
            if ([aScanner scanString:NUCDoubleQuotationMark intoString:nil])
                [aString appendString:NUCDoubleQuotationMark];
            else if ([aScanner scanString:NUCBackslash intoString:nil])
                [aString appendString:NUCBackslash];
        }
    }
    
    return aString;
}

@end
