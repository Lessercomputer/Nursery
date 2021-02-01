//
//  NUCHeaderName.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCHeaderName.h"

#import <Foundation/NSString.h>

@implementation NUCHeaderName

+ (instancetype)preprocessingTokenWithRange:(NSRange)aRange isHChar:(BOOL)anIsHChar;
{
    return [self preprocessingTokenWithContent:nil range:aRange isHChar:anIsHChar];
}

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange isHChar:(BOOL)anIsHChar
{
    return [self preprocessingTokenWithContent:[aString substringWithRange:aRange] range:aRange isHChar:anIsHChar];
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aContent range:(NSRange)aRange isHChar:(BOOL)anIsHChar
{
    return [[[self alloc] initWithContent:aContent range:aRange isHChar:anIsHChar] autorelease];
}

- (instancetype)initWithRange:(NSRange)aRange isHChar:(BOOL)anIsHChar;
{
    return [self initWithContent:nil range:aRange isHChar:anIsHChar];
}

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange isHChar:(BOOL)anIsHChar
{
    if (self = [super initWithContent:aContent region:NURegionFromRange(aRange) type:NUCLexicalElementHeaderNameType])
    {
        isHChar = anIsHChar;
    }
    
    return self;
}

- (BOOL)isHChar
{
    return isHChar;
}

- (BOOL)isQChar
{
    return !isHChar;
}

@end
