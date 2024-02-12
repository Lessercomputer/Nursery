//
//  NUCAdjacentStringLiteral.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCAdjacentStringLiteral.h"
#import <Foundation/NSArray.h>

@implementation NUCAdjacentStringLiteral

+ (instancetype)adjacentStringLiteralWith:(NSArray *)aStringLiterals
{
    return [[[self alloc] initWithType:NUCLexicalElementStringLiteralType stringLiterals:aStringLiterals] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType stringLiterals:(NSArray *)aStringLiterals
{
    if (self = [super initWithType:NUCLexicalElementStringLiteralType])
    {
        _stringLiterals = [aStringLiterals copy];
    }
    
    return self;
}

- (void)dealloc
{
    [_stringLiterals release];
    
    [super dealloc];
}

@end
