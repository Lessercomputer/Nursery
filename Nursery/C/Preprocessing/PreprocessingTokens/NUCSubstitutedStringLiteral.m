//
//  NUCSubstitutedStringLiteral.m
//  Nursery
//
//  Created by aki on 2023/07/07.
//

#import "NUCSubstitutedStringLiteral.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCMacroArgument.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSCharacterSet.h>

@implementation NUCSubstitutedStringLiteral

+ (instancetype)substitutedStringLiteralWithMacroArgument:(NUCMacroArgument *)aMacroArgument
{
    return [[[self alloc] initWithMacroArgument:aMacroArgument] autorelease];
}

- (instancetype)initWithMacroArgument:(NUCMacroArgument *)aMacroArgument
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        macroArgument = [aMacroArgument retain];
    }
    
    return self;
}

- (void)dealloc
{
    [macroArgument release];
    
    [super dealloc];
}

- (NUCMacroArgument *)macroArgument
{
    return macroArgument;
}

- (NSString *)string
{
    if (!string)
        string = [[self getString] retain];
    
    return string;
}

- (NSString *)getString
{
    if ([[self macroArgument] isPlacemaker])
        return @"";
    
    NSArray *aPpTokens = [[self macroArgument] ppTokensByTrimingWhitespaces];;
    NSMutableString *aString = [NSMutableString string];
    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aStream hasNext])
    {
        if ([aStream skipWhitespaces])
        {
            [aString appendString:NUCSpace];
        }
        else
            [aString appendString:[[aStream next] stringForSubstitution]];
    }
    
    return aString;
}

- (void)addStringForConcatinationTo:(NSMutableString *)aString
{
    [aString appendString:[self string]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ string: %@", [super description], [self string]];
}

@end
