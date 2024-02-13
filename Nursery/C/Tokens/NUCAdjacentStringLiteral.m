//
//  NUCAdjacentStringLiteral.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCAdjacentStringLiteral.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

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

- (NSString *)description
{
    NSMutableString *aString = [NSMutableString stringWithFormat:@"<%@ %p> {", [self class], self];
    
    [[self stringLiterals] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [aString appendString:[obj description]];
    }];
    
    [aString appendString:@"}"];
    
    return aString;
}

@end
