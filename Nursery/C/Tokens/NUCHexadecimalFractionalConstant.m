//
//  NUCHexadecimalFractionalConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/17.
//

#import "NUCHexadecimalFractionalConstant.h"
#import <Foundation/NSString.h>

@implementation NUCHexadecimalFractionalConstant

+ (BOOL)hexadecimalFractionalConstantFrom:(NSString *)aString into:(NSString **)aHexadecimalDigitSequence into:(NSString  **)aHexadecimalDigitSequence2 location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer)
        return NO;
    
    NSUInteger aLocation = *aLocationPointer;
    NSRange aDigitSequenceRange = [self rangeOfCharactersFromSet:[NUCLexicalElement NUCHexadecimalDigitCharacterSet] string:aString range:NSMakeRange(aLocation, [aString length] - aLocation)];
    NSRange aPeriodRange = NSMakeRange(aLocation, 0);
    NSRange aDigitSequence2Range = NSMakeRange(NSNotFound, 0);
    NSString *aDigitSequence = nil, *aDigitSequence2 = nil;
    
    if (aDigitSequenceRange.location != NSNotFound)
    {
        aDigitSequence = [aString substringWithRange:aDigitSequenceRange];
        aPeriodRange.location = aLocation + aDigitSequenceRange.length;
    }
    
    aPeriodRange = [aString rangeOfString:NUCPeriod options:NSAnchoredSearch range:NSMakeRange(aPeriodRange.location, [aString length] - aPeriodRange.location)];
    
    if (aPeriodRange.location != NSNotFound)
    {
        NSUInteger aDigitSequence2Location = aDigitSequenceRange.location + 1;
        aDigitSequence2Range = [self rangeOfCharactersFromSet:[NUCLexicalElement NUCHexadecimalDigitCharacterSet] string:aString range:NSMakeRange(aDigitSequence2Location, [aString length] - aDigitSequence2Location)];
        
        if (aDigitSequence2Range.location != NSNotFound)
        {
            aDigitSequence2 = [aString substringWithRange:aDigitSequence2Range];
            *aLocationPointer = NSMaxRange(aDigitSequence2Range);
        }
    }

    if ((aDigitSequence.length > 0 || aDigitSequence.length == 0) && aPeriodRange.length > 0 && aDigitSequence2Range.length > 0)
    {
        if (aHexadecimalDigitSequence)
            *aHexadecimalDigitSequence = aDigitSequence;
        if (aHexadecimalDigitSequence2)
            *aHexadecimalDigitSequence2 = aDigitSequence2;
        *aLocationPointer =  NSMaxRange(aDigitSequence2Range);
        
        return YES;
    }
    else if (aDigitSequence.length > 0 && aPeriodRange.length > 0 && aDigitSequence2 == 0)
    {
        if (aHexadecimalDigitSequence)
            *aHexadecimalDigitSequence = aDigitSequence;
        *aLocationPointer = NSMaxRange(aPeriodRange);
        
        return YES;
    }
    
    return NO;
}

@end
