//
//  NUCIntegerConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/12.
//

#import "NUCIntegerConstant.h"
#import "NUCConstant.h"
#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSString.h>

@implementation NUCIntegerConstant

+ (BOOL)integerConstantFrom:(NUCDecomposedPreprocessingToken *)aPreprocessingToken into:(NUCConstant **)aConstant
{
    if (![aPreprocessingToken isPpNumber])
        return NO;
    
    NUUInt64 aValue = 0;
    NSString *aString = [aPreprocessingToken content];
    
    if ([aString hasPrefix:NUCHexadecimalPrefixSmall] || [aString hasPrefix:NUCHexadecimalPrefixLarge])
    {
        NSRange aHexDigitsRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCHexadecimalDigitCharacterSet] options:0 range:NSMakeRange(2, [aString length] - 2)];
        
        if (aHexDigitsRange.location == NSNotFound)
            return NO;
        
        for (NSUInteger aLocation = aHexDigitsRange.location; NSLocationInRange(aLocation, aHexDigitsRange); aLocation++)
        {
            unichar aCharacter = [aString characterAtIndex:aLocation];
            
            aValue *= 16;
            
            if (aCharacter >= 'a')
                aValue += aCharacter - 'a' + 10;
            else if (aCharacter >= 'A')
                aValue += aCharacter - 'A' + 10;
            else
                aValue += aCharacter - '0';
        }
    }
    else if ([aString hasPrefix:NUCOctalDigitZero])
    {
        NSRange anOctalDigitsRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCOctalDigitCharacterSet]];
        
        if (anOctalDigitsRange.location == NSNotFound)
            return NO;
        
        for (NSUInteger aLocation = anOctalDigitsRange.location; NSLocationInRange(aLocation, anOctalDigitsRange); aLocation++)
        {
            aValue *= 8;
            aValue += [aString characterAtIndex:aLocation] - '0';
        }
    }
    else
    {
        NSRange aDecimalDigitsRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet]];
        
        if (aDecimalDigitsRange.location == NSNotFound)
            return NO;
        
        for (NSUInteger aLocation = aDecimalDigitsRange.location; NSLocationInRange(aLocation, aDecimalDigitsRange) ; aLocation++)
        {
            aValue *= 10;
            aValue += [aString characterAtIndex:aLocation] - '0';
        }
    }
    
    if (aConstant)
        *aConstant = [NUCConstant constantWithIntegerConstant:[NUCIntegerConstant constantWithPpNumber:aPreprocessingToken value:aValue]];
    
    return YES;
}

+ (instancetype)constantWithPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber value:(NUUInt64)aValue
{
    return [[[self alloc] initWithPpNumber:aPpNumber value:aValue] autorelease];
}

- (instancetype)initWithPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber value:(NUUInt64)aValue
{
    if (self = [super initWithType:NUCLexicalElementIntegerConstantType])
    {
        ppNumber = [aPpNumber retain];
        value = aValue;
    }
    
    return self;
}

- (void)dealloc
{
    [ppNumber release];
    
    [super dealloc];
}

@end
