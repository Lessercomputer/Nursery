//
//  NUCIdentifier.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/05/16.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCIdentifier.h"

#import <Foundation/NSString.h>

@implementation NUCIdentifier

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange
{
    return [[[self alloc] initWithContent:[aString substringWithRange:aRange] range:aRange] autorelease];
}

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange
{
    return self = [super initWithContent:aContent range:aRange type:NUCLexicalElementIdentifierType];
}

- (BOOL)isEqual:(id)anOther
{
    if (anOther == self)
        return YES;
    else if (![super isEqual:anOther])
        return NO;
    else
        return [[self content] isEqual:[anOther content]];
}

- (NSUInteger)hash
{
    return [[self content] hash];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return [[[self class] preprocessingTokenWithContentFromString:[self content] range:[self range]] autorelease];
}

@end
