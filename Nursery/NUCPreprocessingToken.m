//
//  NUCPreprocessingToken.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

#import <Foundation/NSString.h>

@implementation NUCPreprocessingToken

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self preprocessingTokenWithContent:[aString substringWithRange:aRange] range:aRange type:anElementType];
}

+ (instancetype)preprocessingTokenWithRange:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self preprocessingTokenWithContent:nil range:aRange type:anElementType];
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aContent range:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self preprocessingTokenWithContent:aContent region:NURegionFromRange(aRange) type:anElementType];
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aContent region:(NURegion)aRange type:(NUCLexicalElementType)anElementType
{
    return [[[self alloc] initWithContent:aContent region:aRange type:anElementType] autorelease];
}



- (instancetype)initWithRange:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self initWithContent:nil range:aRange type:anElementType];
}

- (instancetype)initWithContentFromString:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self initWithContent:[aString substringWithRange:aRange] range:aRange type:anElementType];
}

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self initWithContent:aContent region:NURegionFromRange(aRange) type:anElementType];
}

- (instancetype)initWithContent:(NSString *)aContent region:(NURegion)aRange type:(NUCLexicalElementType)anElementType
{
    if (self = [super init])
    {
        content = [aContent copy];
        type = anElementType;
        range = aRange;
    }
    
    return self;
}

- (void)dealloc
{
    [content release];
    content = nil;
    
    [super dealloc];
}

- (NSString *)content
{
    return content;
}

- (BOOL)isHash
{
    return [self type] == NUCLexicalElementPunctuatorType
                && [[self content] isEqualToString:NUCHash];
}

- (NSString *)description
{
    return content;
    //    return [NSString stringWithFormat:@"<%@: %p> content:%@, type:%lu", [self class], self, [self content], type];
}

@end
