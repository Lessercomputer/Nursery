//
//  NUCIdentifierList.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//

#import "NUCLexicalElement.h"

@class NUCPreprocessingTokenStream, NUCDecomposedPreprocessingToken, NUCIdentifier;

@interface NUCIdentifierList : NUCLexicalElement
{
    NSMutableArray *identifiers;
}

+ (BOOL)identifierListFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCIdentifierList **)aToken;

+ (instancetype)identifierList;

- (void)add:(NUCIdentifier *)anIdentifier;
- (NSMutableArray *)identifiers;
- (NSUInteger)count;
- (BOOL)contains:(NUCIdentifier *)anIdentifier;
- (NSUInteger)indexOf:(NUCIdentifier *)anIdentifier;

- (void)enumerateObjectsUsingBlock:(void (^)(NUCDecomposedPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop))aBlock;

@end

