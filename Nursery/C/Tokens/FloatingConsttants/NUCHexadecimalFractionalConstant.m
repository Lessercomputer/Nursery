//
//  NUCHexadecimalFractionalConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/17.
//

#import "NUCHexadecimalFractionalConstant.h"
#import <Foundation/NSString.h>

@implementation NUCHexadecimalFractionalConstant

+ (NSCharacterSet *)digitSequenceCharacterSet
{
    return [self NUCHexadecimalDigitCharacterSet];
}

- (NSString *)hexadecimalDigitSequence
{
    return [self digitSequence];
}

- (NSString *)hexadecimalDigitSequence2
{
    return [self digitSequence2];
}

@end
