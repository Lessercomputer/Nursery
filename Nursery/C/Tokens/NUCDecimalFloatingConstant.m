//
//  NUCDecimalFloatingConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCDecimalFloatingConstant.h"
#import "NUCFractionalConstant.h"
#import "NUCExponentPart.h"
#import <Foundation/NSString.h>

@implementation NUCDecimalFloatingConstant

+ (instancetype)floatingConstantWithFractionalConstant:(NUCFractionalConstant *)aFractionalConstant exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix
{
    return [[[self alloc] initWithType:NUCLexicalElementNone fractionalConstant:aFractionalConstant exponentPart:anExponentPart floatingSuffix:aFloatingSuffix] autorelease];
}

+ (instancetype)floatingConstantWithDigitSequence:(NSString *)aDigitSequence exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix
{
    return [[[self alloc] initWithType:NUCLexicalElementNone digitSequence:aDigitSequence exponentPart:anExponentPart floatingSuffix:aFloatingSuffix] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType fractionalConstant:(NUCFractionalConstant *)aFractionalConstant exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        _fractionalConstant = [aFractionalConstant retain];
        _exponentPart = [anExponentPart retain];
        _floatingSuffix = [aFloatingSuffix copy];
    }
    
    return self;
}

- (instancetype)initWithType:(NUCLexicalElementType)aType digitSequence:(NSString *)aDigitSequence exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix
{
    if (self = [super initWithType:NUCLexicalElementNone])
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
