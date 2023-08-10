//
//  NUCStringLiteral.m
//  Nursery
//
//  Created by aki on 2023/05/24.
//

#import "NUCStringLiteral.h"

#import <Foundation/NSString.h>

@implementation NUCStringLiteral

+ (instancetype)preprocessingTokenWithContent:(NSString *)aString range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix
{
    return [[[self alloc] initWithContent:aString range:aRange encodingPrefix:anEncodingPrefix] autorelease];
}

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix
{
    if (self = [super initWithContent:aContent range:aRange type:NUCLexicalElementStringLiteralType])
    {
        encodingPrefix = [anEncodingPrefix copy];
    }
    
    return self;
}

- (void)dealloc
{
    [encodingPrefix release];
    
    [super dealloc];
}

- (NSString *)encodingPrefix
{
    return encodingPrefix;
}

- (NSString *)string
{
    return [NSString stringWithFormat:@"%@\"%@\"", [self encodingPrefix] ? [self encodingPrefix] : @"", [self content]];
}

- (NSString *)stringForSubstitution
{
    return [NSString stringWithFormat:@"%@\\\"%@\"", [self encodingPrefix] ? [self encodingPrefix] : @"", [self content]];
}

@end
