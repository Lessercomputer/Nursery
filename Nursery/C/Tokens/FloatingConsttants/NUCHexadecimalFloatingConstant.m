//
//  NUCHexadecimalFloatingConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/17.
//

#import "NUCHexadecimalFloatingConstant.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCHexadecimalFractionalConstant.h"
#import <Foundation/NSString.h>

@implementation NUCHexadecimalFloatingConstant

+ (BOOL)floatingConstantFromPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber into:(NUCConstant **)aConstant
{
    if (![aPpNumber isPpNumber])
        return NO;
    
    NSString *aString = [aPpNumber content];
    NSUInteger aLocation = 0;
    
    NSString *aHexadecimalPrefix = nil;
    if (![self hexadecimalPrefixFrom:aString into:&aHexadecimalPrefix location:&aLocation])
        return NO;
    
    NSString *aDigitSequence = nil, *aDigitSequence2 = nil;
    NUCHexadecimalFractionalConstant *aFractionalConstant = nil;
    
    if ([NUCHexadecimalFractionalConstant fractionalConstantFrom:aString into:&aDigitSequence into:&aDigitSequence2 location:&aLocation])
    {
        
    }
    else
        ;
    
    return NO;
}
+ (BOOL)hexadecimalPrefixFrom:(NSString *)aString into:(NSString **)aPrefix location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer)
        return NO;
    
    NSUInteger aLocation = *aLocationPointer;
    NSRange aRange = NSMakeRange(aLocation, 2);
    NSString *aHexadecimalPrefix = nil;
    
    if ([aString compare:NUCHexadecimalPrefixSmall options:NSAnchoredSearch range:aRange] == NSOrderedSame)
        aHexadecimalPrefix = NUCHexadecimalPrefixSmall;
    else if ([aString compare:NUCHexadecimalPrefixLarge options:NSAnchoredSearch range:aRange] == NSOrderedSame)
        aHexadecimalPrefix = NUCHexadecimalPrefixLarge;
    else
        return NO;
    
    if (aPrefix)
        *aPrefix = aHexadecimalPrefix;
    *aLocationPointer = aLocation + 2;
    
    return YES;;
}

- (void)dealloc
{
    [_hexadecimalPrefix release];
    [_hexadecimalFractionalConstant release];
    [_hexadecimalDigitSequence release];
    [_binaryExponentPart release];
    [_floatingSuffix release];
    
    [super dealloc];
}

@end
