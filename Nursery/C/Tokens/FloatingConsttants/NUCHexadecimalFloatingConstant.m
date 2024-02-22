//
//  NUCHexadecimalFloatingConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/17.
//

#import "NUCHexadecimalFloatingConstant.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCHexadecimalFractionalConstant.h"
#import "NUCBinaryExponentPart.h"
#import "NUCConstant.h"
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
        aFractionalConstant = [NUCHexadecimalFractionalConstant constantWithDigitSequence:aDigitSequence digitSequence2:aDigitSequence2];
    }
    else if ([self digitSequenceFrom:aString at:&aLocation into:&aDigitSequence])
        ;
    else
        return NO;
    
    NUCBinaryExponentPart *anExponentPart = [NUCBinaryExponentPart exponentPartWith:aString location:&aLocation];
    if (!anExponentPart)
        return NO;
    
    NSString *aFloatingSuffix = nil;
    [self floatingSuffixFrom:aString into:&aFloatingSuffix location:&aLocation];
    
    NUCHexadecimalFloatingConstant *aFloatingConstant = nil;
    
    if (aFractionalConstant)
        aFloatingConstant = [NUCHexadecimalFloatingConstant floatingConstantWithHexadecimalPrefix:aHexadecimalPrefix fractionalConstant:aFractionalConstant exponentPart:anExponentPart floatingSuffix:aFloatingSuffix ppNumber:aPpNumber];
    else
        aFloatingConstant = [NUCHexadecimalFloatingConstant floatingConstantWithHexadecimalPrefix:aHexadecimalPrefix digitSequence:aDigitSequence exponentPart:anExponentPart floatingSuffix:aFloatingSuffix ppNumber:aPpNumber];
    
    if (aConstant)
        *aConstant = [NUCConstant constantWithFloatingConstant:aFloatingConstant];
    
    return YES;
}

+ (BOOL)hexadecimalPrefixFrom:(NSString *)aString into:(NSString **)aPrefix location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer)
        return NO;
    
    NSUInteger aLocation = *aLocationPointer;
    NSRange aRange = NSMakeRange(aLocation, 2);
    NSString *aHexadecimalPrefix = nil;
    
    if (!NSLocationInRange(NSMaxRange(aRange) - 1, NSMakeRange(aLocation, [aString length] - aLocation)))
        return NO;
    
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

+ (instancetype)floatingConstantWithHexadecimalPrefix:(NSString *)aPrefix fractionalConstant:(NUCHexadecimalFractionalConstant *)aFractionalConstant exponentPart:(NUCBinaryExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber
{
    return [[[self alloc] initWithType:NUCLexicalElementNone hexadecimalPrefix:aPrefix fractionalConstant:aFractionalConstant exponentPart:anExponentPart floatingSuffix:aFloatingSuffix ppNumber:aPpNumber] autorelease];
}

+ (instancetype)floatingConstantWithHexadecimalPrefix:(NSString *)aPrefix digitSequence:(NSString *)aDigitSequence exponentPart:(NUCBinaryExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber
{
    return [[[self alloc] initWithType:NUCLexicalElementNone hexadecimalPrefix:aPrefix digitSequence:aDigitSequence exponentPart:anExponentPart floatingSuffix:aFloatingSuffix ppNumber:aPpNumber] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType hexadecimalPrefix:(NSString *)aPrefix fractionalConstant:(NUCHexadecimalFractionalConstant *)aFractionalConstant exponentPart:(NUCBinaryExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber
{
    if (self = [super initWithType:NUCLexicalElementNone ppNumber:aPpNumber])
    {
        _hexadecimalPrefix = [aPrefix copy];
        _hexadecimalFractionalConstant = [aFractionalConstant retain];
        _binaryExponentPart = [anExponentPart retain];
        _floatingSuffix = [aFloatingSuffix copy];
    }
    
    return self;
}

- (instancetype)initWithType:(NUCLexicalElementType)aType hexadecimalPrefix:(NSString *)aPrefix digitSequence:(NSString *)aDigitSequence exponentPart:(NUCBinaryExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber
{
    if (self = [super initWithType:NUCLexicalElementNone ppNumber:aPpNumber])
    {
        _hexadecimalPrefix = [aPrefix copy];
        _hexadecimalDigitSequence = [aDigitSequence copy];
        _binaryExponentPart = [anExponentPart retain];
        _floatingSuffix = [aFloatingSuffix copy];
    }
    
    return self;
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
