//
//  NUCLogicalANDExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/14.
//

#import "NUCLogicalANDExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCInclusiveORExpression.h"

@implementation NUCLogicalANDExpression

+ (BOOL)logicalANDExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalANDExpression **)aToken
{
    NUCInclusiveORExpression *anInclusiveORExpression = nil;
    
    if ([NUCInclusiveORExpression inclusiveORExpressionFrom:aStream into:&anInclusiveORExpression])
    {
        if (aToken)
            *aToken = [NUCLogicalANDExpression expressionWithInclusiveORExpression:anInclusiveORExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCLogicalANDExpression *anAndExpression = nil;
        
        if ([self logicalANDExpressionFrom:aStream into:&anAndExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *aLogicalANDOperator = [aStream next];
            if ([aLogicalANDOperator isLogicalANDOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCInclusiveORExpression inclusiveORExpressionFrom:aStream into:&anInclusiveORExpression])
                {
                    if (aToken)
                        *aToken = [NUCLogicalANDExpression expressionWithLogicalANDExpression:anAndExpression logicalANDOperator:aLogicalANDOperator inclusiveORExpression:anInclusiveORExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}

+ (instancetype)expressionWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression
{
    return [[[self alloc] initWithInclusiveORExpression:anInclusiveORExpression] autorelease];
}

+ (instancetype)expressionWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression logicalANDOperator:(NUCDecomposedPreprocessingToken *)aLogicalANDOperator inclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression
{
    return [[[self alloc] initWithLogicalANDExpression:aLogicalANDExpression logicalANDOperator:aLogicalANDOperator inclusiveORExpression:anInclusiveORExpression] autorelease];
}

- (instancetype)initWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression
{
    return [self initWithLogicalANDExpression:nil logicalANDOperator:nil inclusiveORExpression:anInclusiveORExpression];
}

- (instancetype)initWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression logicalANDOperator:(NUCDecomposedPreprocessingToken *)aLogicalANDOperator inclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression
{
    if (self = [super initWithType:NUCLexicalElementLogicalANDExpressionType])
    {
        inclusiveORExpression = [anInclusiveORExpression retain];
        logicalANDExpression = [aLogicalANDExpression retain];
        logicalANDOperator = [aLogicalANDOperator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [inclusiveORExpression release];
    [logicalANDExpression release];
    [logicalANDOperator release];
    
    [super dealloc];
}

@end
