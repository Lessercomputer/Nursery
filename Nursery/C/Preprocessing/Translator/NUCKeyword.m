//
//  NUCKeyword.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCKeyword.h"

@implementation NUCKeyword

+ (instancetype)tokenWith:(NUCDecomposedPreprocessingToken *)aPpToken
{
    return [[[self alloc] initWithType:NUCLexicalElementKeywordType ppToken:aPpToken] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType ppToken:(NUCDecomposedPreprocessingToken *)aPpToken
{
    if (self = [super initWithType:NUCLexicalElementKeywordType])
    {
        _identifier = [aPpToken retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_identifier release];
    
    [super dealloc];
}

@end
