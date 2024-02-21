//
//  NUCDecimalFloatingConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCDecimalFloatingConstant.h"
#import "NUCFractionalConstant.h"
#import "NUCExponentPart.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConstant.h"
#import <Foundation/NSString.h>

@implementation NUCDecimalFloatingConstant

+ (BOOL)floatingConstantFromPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber into:(NUCConstant **)aConstant
{
    if (![aPpNumber isPpNumber])
        return NO;
    
    NSString *aString = [aPpNumber content];
    NSString *aDigitSequence = nil, *aDigitSequence2 = nil;
    NSUInteger aLocation = 0;
    
    if ([NUCFractionalConstant fractionalConstantFrom:aString into:&aDigitSequence into:&aDigitSequence2 location:&aLocation])
    {
        NUCExponentPart *anExponentPart = [NUCExponentPart exponentPartWith:aString location:&aLocation];
        
        NSString *aFloatingSuffix = nil;
        [self floatingSuffixFrom:aString into:&aFloatingSuffix location:&aLocation];
        
        NUCFractionalConstant *aFractionalConstant = [NUCFractionalConstant constantWithDigitSequence:aDigitSequence digitSequence2:aDigitSequence2];
        
        NUCDecimalFloatingConstant *aDecimalFloatingConstant = [NUCDecimalFloatingConstant floatingConstantWithFractionalConstant:aFractionalConstant exponentPart:anExponentPart floatingSuffix:aFloatingSuffix ppNumber:aPpNumber];
        
        if (aConstant)
            *aConstant = [NUCConstant constantWithFloatingConstant:aDecimalFloatingConstant];
        
        return YES;
    }
    else
    {
        if ([self digitSequenceFrom:aString at:&aLocation into:&aDigitSequence])
        {
            NUCExponentPart *anExponentPart = [NUCExponentPart exponentPartWith:aString location:&aLocation];
            if (anExponentPart)
            {
                NSString *aFloatingSuffix = nil;
                [self floatingSuffixFrom:aString into:&aFloatingSuffix location:&aLocation];
                
                NUCDecimalFloatingConstant *aDecimalFloatingConstant = [NUCDecimalFloatingConstant floatingConstantWithDigitSequence:aDigitSequence exponentPart:anExponentPart floatingSuffix:aFloatingSuffix ppNumber:aPpNumber];
                
                if (aConstant)
                    *aConstant = [NUCConstant constantWithFloatingConstant:aDecimalFloatingConstant];
                
                return YES;
            }
        }
    }
    
    return NO;
}

+ (instancetype)floatingConstantWithFractionalConstant:(NUCFractionalConstant *)aFractionalConstant exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber
{
    return [[[self alloc] initWithType:NUCLexicalElementNone fractionalConstant:aFractionalConstant exponentPart:anExponentPart floatingSuffix:aFloatingSuffix ppNumber:aPpNumber] autorelease];
}

+ (instancetype)floatingConstantWithDigitSequence:(NSString *)aDigitSequence exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber
{
    return [[[self alloc] initWithType:NUCLexicalElementNone digitSequence:aDigitSequence exponentPart:anExponentPart floatingSuffix:aFloatingSuffix ppNumber:aPpNumber] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType fractionalConstant:(NUCFractionalConstant *)aFractionalConstant exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber
{
    if (self = [super initWithType:NUCLexicalElementNone ppNumber:aPpNumber])
    {
        _fractionalConstant = [aFractionalConstant retain];
        _exponentPart = [anExponentPart retain];
        _floatingSuffix = [aFloatingSuffix copy];
    }
    
    return self;
}

- (instancetype)initWithType:(NUCLexicalElementType)aType digitSequence:(NSString *)aDigitSequence exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber
{
    if (self = [super initWithType:NUCLexicalElementNone ppNumber:aPpNumber])
    {
        _digitSequence = [aDigitSequence copy];
        _exponentPart = [anExponentPart retain];
        _floatingSuffix = [aFloatingSuffix copy];
    }
    
    return self;
}

- (void)dealloc
{
    [_fractionalConstant release];
    [_digitSequence release];
    [_exponentPart release];
    [_floatingSuffix release];
    
    [super dealloc];
}

- (NSString *)description
{
    NUCFractionalConstant *aFractionalConstant = [self fractionalConstant];
    
    if (aFractionalConstant)
        return [NSString stringWithFormat:@"<%@ %p> %@.%@%@%@", [self class], self, [aFractionalConstant digitSequence], [aFractionalConstant digitSequence2], [self exponentPart], [self floatingSuffix]];
    else
        return [NSString stringWithFormat:@"<%@ %p> %@%@%@", [self class], self, [self digitSequence], [self exponentPart], [self floatingSuffix]];
}

@end
