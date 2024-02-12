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

- (void)dealloc
{
    [_fractionalConstant release];
    [_exponentPart release];
    [_floatingSuffix release];
    
    [super dealloc];
}

@end
