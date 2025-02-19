//
//  NUCIdentifier.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/05/16.
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

- (NSString *)string
{
    return [self content];
}

- (BOOL)isPredefinedMacroVA_ARGS
{
    return [[self content] isEqual:NUCPredefinedMacroVA_ARGS];
}

- (BOOL)isEqualToString:(NSString *)aString
{
    return [[self string] isEqualToString:aString];
}

@end
