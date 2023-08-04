//
//  NUCHeaderName.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
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
    if (self = [super initWithContent:aContent range:aRange type:NUCLexicalElementHeaderNameType])
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

- (BOOL)isEqual:(id)anObject
{
    if (self == anObject)
        return YES;
    else
    {
        if ([anObject isKindOfClass:[NUCHeaderName class]])
            if (([self isHChar] && ![anObject isHChar])
                || (![self isHChar] && [anObject isHChar]))
                return NO;
        
        return [super isEqual:anObject];
    }
}

@end
