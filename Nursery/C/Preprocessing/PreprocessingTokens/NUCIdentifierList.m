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
    NSUInteger aPosition = [aStream position];
    NUCIdentifierList *anIdentifierList = [NUCIdentifierList identifierList];
    
    [aStream skipWhitespacesWithoutNewline];
    NUCDecomposedPreprocessingToken *anIdentifierOrNot = [aStream next];
    
    if ([anIdentifierOrNot isIdentifier])
    {
        [anIdentifierList add:(NUCIdentifier *)anIdentifierOrNot];
        
        while ([aStream hasNext])
        {
            NSUInteger aPosition = [aStream position];
            
            [aStream skipWhitespacesWithoutNewline];
            NUCDecomposedPreprocessingToken *aCommaOrNot = [aStream next];
            
            if ([aCommaOrNot isComma])
            {
                [aStream skipWhitespacesWithoutNewline];
                anIdentifierOrNot = [aStream next];
                
                if ([anIdentifierOrNot isIdentifier])
                    [anIdentifierList add:(NUCIdentifier *)anIdentifierOrNot];
                else
                {
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
    }
    else
        [aStream setPosition:aPosition];
    
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
