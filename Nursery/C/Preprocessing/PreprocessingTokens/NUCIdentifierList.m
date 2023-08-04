//
//  NUCIdentifierList.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//

#import "NUCIdentifierList.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSArray.h>

@implementation NUCIdentifierList

+ (BOOL)identifierListFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCIdentifierList **)aToken
{
    NUCIdentifierList *anIdentifierList = [NUCIdentifierList identifierList];
        
    while ([aStream hasNext])
    {
        NSUInteger aPosition = [aStream position];
        NUCDecomposedPreprocessingToken *aPpToken1 = nil, *aPpToken2 = nil, *aPpToken3 = nil;
        
        [aStream skipWhitespacesWithoutNewline];
        aPpToken1 = [aStream next];
        
        if ([aPpToken1 isIdentifier])
        {
            aPosition = [aStream position];
            [aStream skipWhitespacesWithoutNewline];
            aPpToken2 = [aStream next];
            
            if ([aPpToken2 isComma])
            {
                [aStream skipWhitespacesWithoutNewline];
                aPpToken3 = [aStream next];
                
                if ([aPpToken3 isIdentifier])
                {
                    [anIdentifierList add:(NUCIdentifier *)aPpToken1];
                    [anIdentifierList add:(NUCIdentifier *)aPpToken3];
                }
                else
                {
                    [anIdentifierList add:(NUCIdentifier *)aPpToken1];
                    [aStream setPosition:aPosition];
                    break;
                }
            }
            else
            {
                [anIdentifierList add:(NUCIdentifier *)aPpToken1];
                [aStream setPosition:aPosition];
                break;
            }
        }
        else
        {
            [aStream setPosition:aPosition];
            break;
        }
    }
    
    if ([anIdentifierList count])
    {
        if (aToken)
            *aToken = anIdentifierList;
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)identifierList
{
    return [[[self alloc] initWithType:NUCLexicalElementIdentifierListType] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        identifiers = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [identifiers release];
    
    [super dealloc];
}

- (void)add:(NUCIdentifier *)anIdentifier
{
    [[self identifiers] addObject:anIdentifier];
}

- (NSMutableArray *)identifiers
{
    return identifiers;
}

- (NSUInteger)count
{
    return [[self identifiers] count];
}

- (BOOL)contains:(NUCIdentifier *)anIdentifier
{
    return [[self identifiers] containsObject:anIdentifier];
}

- (NSUInteger)indexOf:(NUCIdentifier *)anIdentifier
{
    return [[self identifiers] indexOfObject:anIdentifier];
}

- (void)enumerateObjectsUsingBlock:(void (^)(NUCDecomposedPreprocessingToken *, NSUInteger, BOOL *))aBlock
{
    [[self identifiers] enumerateObjectsUsingBlock:aBlock];
}

@end
