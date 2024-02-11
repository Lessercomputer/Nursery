//
//  NUCToken.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCToken.h"
#import "NUCDecomposedPreprocessingToken.h"
#import <Foundation/NSArray.h>

@implementation NUCToken

+ (BOOL)ppTokenIsKeyword:(NUCDecomposedPreprocessingToken *)aPpToken
{
    return [[NUCLexicalElement NUCKeywords] containsObject:[aPpToken content]];
}

@end
