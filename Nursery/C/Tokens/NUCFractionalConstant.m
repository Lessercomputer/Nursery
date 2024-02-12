//
//  NUCFractionalConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCFractionalConstant.h"

#import <Foundation/NSString.h>

@implementation NUCFractionalConstant

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
