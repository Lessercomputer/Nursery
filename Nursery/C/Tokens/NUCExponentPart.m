//
//  NUCExponentPart.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCExponentPart.h"
#import <Foundation/NSString.h>

@implementation NUCExponentPart

+ (instancetype)exponentPartWithSmallEOrLargeE:(NSString *)aSmallEOrLargeE sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence
{
    return [[[self alloc] initWithType:NUCLexicalElementNone smallEOrLargeE:aSmallEOrLargeE sign:aSign digitSequence:aDigitSequence] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType smallEOrLargeE:(NSString *)aSmallEOrLargeE sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        _smallEOrLargeE = [aSmallEOrLargeE copy];
        _sign = [aSign copy];
        _digitSequence = [aDigitSequence copy];
    }
    
    return self;
}

- (void)dealloc
{
    [_smallEOrLargeE release];
    [_sign release];
    [_digitSequence release];
    
    [super dealloc];
}

@end
