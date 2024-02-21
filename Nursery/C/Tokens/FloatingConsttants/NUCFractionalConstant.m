//
//  NUCFractionalConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCFractionalConstant.h"

#import <Foundation/NSString.h>

@implementation NUCFractionalConstant

+ (BOOL)fractionalConstantFrom:(NSString *)aString into:(NSString **)aHexadecimalDigitSequence into:(NSString  **)aHexadecimalDigitSequence2 location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer)
        return NO;
    
    NSUInteger aLocation = *aLocationPointer;
    NSRange aDigitSequenceRange = [self rangeOfCharactersFromSet:[self digitSequenceCharacterSet] string:aString range:NSMakeRange(aLocation, [aString length] - aLocation)];
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
        NSUInteger aDigitSequence2Location = NSMaxRange(aPeriodRange);
        aDigitSequence2Range = [self rangeOfCharactersFromSet:[self digitSequenceCharacterSet] string:aString range:NSMakeRange(aDigitSequence2Location, [aString length] - aDigitSequence2Location)];
        
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

+ (NSCharacterSet *)digitSequenceCharacterSet
{
    return [self NUCDigitCharacterSet];
}

+ (instancetype)constantWithDigitSequence:(NSString *)aDigitSequence digitSequence2:(NSString *)aDigitSequence2
{
    return [[[self alloc] initWithType:NUCLexicalElementNone digitSequence:aDigitSequence digitSequence2:aDigitSequence2] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType digitSequence:(NSString *)aDigitSequence digitSequence2:(NSString *)aDigitSequence2
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        _digitSequence = [aDigitSequence copy];
        _digitSequence2 = [aDigitSequence2 copy];
    }
    
    return self;
}

- (void)dealloc
{
    [_digitSequence release];
    [_digitSequence2 release];
    
    [super dealloc];
}

@end
