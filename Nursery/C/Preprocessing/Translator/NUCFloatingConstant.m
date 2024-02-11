//
//  NUCFloatingConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCFloatingConstant.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConstant.h"

#import <Foundation/NSString.h>

@implementation NUCFloatingConstant

+ (BOOL)floatingConstantFromPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber into:(NUCConstant **)aConstant
{
    NSString *aString = [aPpNumber content];
    NUUInt64 aDigitSequence = 0, aDigitSequence2 = 0;
    
    if ([self fractionalConstantFrom:aString into:&aDigitSequence into:&aDigitSequence2])
    {
        
    }
    
    return NO;
}

+ (BOOL)fractionalConstantFrom:(NSString *)aString into:(NUUInt64*)aDigitSequence into:(NUUInt64 *)aDIgitSequence2
{
    NSRange aDigitsRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet]];
    NSRange aDigitsRange2 = NSMakeRange(NSNotFound, 0);
    
    if (aDigitsRange.location != NSNotFound)
    {
        NSUInteger aLocation = NSMaxRange(aDigitsRange);
        if (aLocation < [aString length])
        {
            unichar aPeriodOrNot = [aString characterAtIndex:aLocation];
            if (aPeriodOrNot == '.')
            {
                aDigitsRange2 = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet] options:0 range:NSMakeRange(aLocation + 1, [aString length] - aLocation)];
                
                if (aDigitsRange2.location != NSNotFound)
                {
                    if (aDigitSequence)
                        *aDigitSequence = [self intFromString:aString withRange:aDigitsRange];
                    if (aDIgitSequence2)
                        *aDIgitSequence2 = [self intFromString:aString withRange:aDigitsRange2];
                    
                    return YES;
                }
            }
        }
    }
    else
    {
        if ([aString hasPrefix:NUCPeriod])
        {
            aDigitsRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet] options:0 range:NSMakeRange(1, [aString length] - 1)];
            
            if (aDigitsRange.location != NSNotFound)
            {
                if (aDigitSequence)
                    *aDigitSequence = [self intFromString:aString withRange:aDigitsRange];
                
                return YES;
            }
        }
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
