//
//  NUCFloatingConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCFloatingConstant.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConstant.h"
#import "NUCDecimalFloatingConstant.h"
#import "NUCFractionalConstant.h"
#import "NUCExponentPart.h"

#import <Foundation/NSString.h>

@implementation NUCFloatingConstant

+ (BOOL)floatingConstantFromPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber into:(NUCConstant **)aConstant
{
    if (![aPpNumber isPpNumber])
        return NO;
    
    NSString *aString = [aPpNumber content];
    NSString *aDigitSequence = nil, *aDigitSequence2 = nil;
    NSUInteger aLocation = 0;
    
    if ([self fractionalConstantFrom:aString into:&aDigitSequence into:&aDigitSequence2 location:&aLocation])
    {
        NSString *aSmallEOrLargeE = nil, *aSign = nil, *anExponentPartDigitSequence = nil;;
        [self expornentPartFrom:aString into:&aSmallEOrLargeE into:&aSign into:&anExponentPartDigitSequence location:&aLocation];
        
        NSString *aFloatingSuffix = nil;
        [self floatingSuffixFrom:aString into:&aFloatingSuffix location:&aLocation];
        
        NUCFractionalConstant *aFractionalConstant = [NUCFractionalConstant constantWithDigitSequence:aDigitSequence digitSequence2:aDigitSequence2];
        
        NUCExponentPart *anExponentPart = [NUCExponentPart exponentPartWithSmallEOrLargeE:aSmallEOrLargeE sign:aSign digitSequence:anExponentPartDigitSequence];
        
        NUCDecimalFloatingConstant *aDecimalFloatingConstant = [NUCDecimalFloatingConstant floatingConstantWithFractionalConstant:aFractionalConstant exponentPart:anExponentPart floatingSuffix:aFloatingSuffix];
        
        if (aConstant)
            *aConstant = [NUCConstant constantWithFloatingConstant:aDecimalFloatingConstant];
        
        return YES;
    }
    else
    {
        
    }
    
    return NO;
}

+ (BOOL)fractionalConstantFrom:(NSString *)aString into:(NSString **)aDigitSequence into:(NSString  **)aDIgitSequence2 location:(NSUInteger *)aLocation
{
    NSRange aDigitSequenceRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet]];
    NSRange aDigitsRange2 = NSMakeRange(NSNotFound, 0);
    
    if (aDigitSequenceRange.location != NSNotFound)
    {
        NSUInteger aLocation = NSMaxRange(aDigitSequenceRange);
        if (aLocation < [aString length])
        {
            if ([aString compare:NUCPeriod options:0 range:NSMakeRange(aLocation, 1)] == NSOrderedSame)
            {
                aDigitsRange2 = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet] options:0 range:NSMakeRange(aLocation + 1, [aString length] - aLocation)];
                
                if (aDigitsRange2.location != NSNotFound)
                {
                    if (aDigitSequence)
                        *aDigitSequence = [aString substringWithRange:aDigitSequenceRange];
                    if (aDIgitSequence2)
                        *aDIgitSequence2 = [aString substringWithRange:aDigitsRange2];
                    
                    return YES;
                }
            }
        }
    }
    else
    {
        if ([aString hasPrefix:NUCPeriod])
        {
            aDigitSequenceRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet] options:0 range:NSMakeRange(1, [aString length] - 1)];
            
            if (aDigitSequenceRange.location != NSNotFound)
            {
                if (aDigitSequence)
                    *aDigitSequence = [aString substringWithRange:aDigitSequenceRange];
                
                if (aLocation)
                    *aLocation = NSMaxRange(aDigitSequenceRange);
                
                return YES;
            }
        }
    }
    
    return NO;
}

+ (BOOL)expornentPartFrom:(NSString *)aString into:(NSString **)aSmallEOrLargeE into:(NSString **)aSign into:(NSString **)aDigitSequence location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer)
        return NO;
    
    NSUInteger aLocation = *aLocationPointer;
    NSString *aSmallEOrLageEToReturn = nil;
    NSRange aRange = NSMakeRange(aLocation, 1);
    
    if ([aString compare:NUCSmallE options:0 range:aRange] == NSOrderedSame)
        aSmallEOrLageEToReturn = NUCSmallE;
    else if ([aString compare:NUCLargeE options:0 range:aRange] == NSOrderedSame)
        aSmallEOrLageEToReturn = NUCLargeE;
    else
        return NO;
    
    aLocation++;
    
    NSString *aSignToReturn = nil;
    [self signFrom:aString into:&aSignToReturn location:&aLocation];
    
    NSString *aDigitSequenceToReturn = nil;
    if ([self digitSequenceFrom:aString at:aLocation into:&aDigitSequenceToReturn])
    {
        
        *aLocationPointer = aLocation;
        
        if (aDigitSequence)
            *aDigitSequence = aDigitSequenceToReturn;
        
        return  YES;
    }
    
    return NO;
}

+ (BOOL)signFrom:(NSString *)aString into:(NSString **)aSign location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer)
        return NO;
    
    NSUInteger aLocation = *aLocationPointer;
    NSRange aRange = NSMakeRange(aLocation, 1);
    NSString *aSignToReturn = nil;
    
    if ([aString compare:NUCPlusSign options:0 range:aRange] == NSOrderedSame)
        aSignToReturn = NUCPlusSign;
    else if ([aString compare:NUCMinusSign options:0 range:aRange])
        aSignToReturn = NUCMinusSign;
    else
        return NO;
    
    *aLocationPointer = aLocation + 1;
    if (aSign)
        *aSign = aSignToReturn;
    
    return YES;
}

+ (BOOL)floatingSuffixFrom:(NSString *)aString into:(NSString **)aFloatingSuffix location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer)
        return NO;
    
    NSUInteger aLocation = *aLocationPointer;
    NSRange aRange = NSMakeRange(aLocation, 1);
    NSString *aSuffixToReturn = nil;
    
    if ([aString compare:NUCSmallF options:0 range:aRange])
        aSuffixToReturn = NUCSmallF;
    else if ([aString compare:NUCSmallL options:0 range:aRange])
        aSuffixToReturn = NUCSmallL;
    else if ([aString compare:NUCLargeF options:0 range:aRange])
        aSuffixToReturn = NUCLargeF;
    else if ([aString compare:NUCLargeL options:0 range:aRange])
        aSuffixToReturn = NUCLargeL;
    else
        return NO;
    
    if (aFloatingSuffix)
        *aFloatingSuffix = aSuffixToReturn;
    *aLocationPointer = aLocation + 1;
    
    return YES;
}

+ (BOOL)digitSequenceFrom:(NSString *)aString at:(NSUInteger)aLocation into:(NSString **)aDigitSequence
{
    NSRange aDigitSequenceRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet] options:0 range:NSMakeRange(aLocation, [aString length] - aLocation)];
    
    if (aDigitSequenceRange.location != NSNotFound)
    {
        if (aDigitSequence)
            *aDigitSequence = [aString substringWithRange:aDigitSequenceRange];
        
        return YES;
    }
    
    return NO;
}

+ (NUUInt64)intFromString:(NSString *)aString withRange:(NSRange)aDecimalDigitsRange
{
    NUUInt64 aValue = 0;
    
    for (NSUInteger aLocation = aDecimalDigitsRange.location; NSLocationInRange(aLocation, aDecimalDigitsRange) ; aLocation++)
    {
        aValue *= 10;
        aValue += [aString characterAtIndex:aLocation] - '0';
    }
    
    return aValue;
}

@end
