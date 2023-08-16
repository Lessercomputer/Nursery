//
//  NUCCharacterConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/08/10.
//

#import "NUCCharacterConstant.h"

#import <Foundation/NSString.h>

@implementation NUCCharacterConstant

+ (instancetype)preprocessingTokenWithContent:(NSString *)aString range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix
{
    return [[[self alloc] initWithContent:aString range:aRange encodingPrefix:anEncodingPrefix] autorelease];
}

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix
{
    if (self = [super initWithContent:aContent range:aRange type:NUCLexicalElementCharacterConstantType])
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
    return [NSString stringWithFormat:@"%@\'%@\'", [self encodingPrefix] ? [self encodingPrefix] : @"", [self content]];
}

@end
