//
//  NUCLogicalORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCLogicalORExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCLogicalANDExpression.h"
#import "NUCDecomposedPreprocessingToken.h"

@implementation NUCLogicalORExpression

+ (BOOL)logicalORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalORExpression **)aToken
{
    NUCLogicalANDExpression *anAndExpression = nil;
    
    if ([NUCLogicalANDExpression logicalANDExpressionFrom:aStream into:&anAndExpression])
    {
        if (aToken)
            *aToken = [NUCLogicalORExpression expressionWithLogicalANDExpression:anAndExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCLogicalORExpression *anORExpression = nil;
        
        if ([self logicalORExpressionFrom:aStream into:&anORExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOROperator = [aStream next];
            if ([anOROperator isLogicalOROperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCLogicalANDExpression logicalANDExpressionFrom:aStream into:&anAndExpression])
                {
                    if (aToken)
                        *aToken = [NUCLogicalORExpression expressionWithlogicalORExpression:anORExpression logicalOREperator:anOROperator logicalANDExpression:anAndExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        return NO;
    }
}

+ (instancetype)expressionWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression
{
    return [[[self alloc] initWithLogicalANDExpression:aLogicalANDExpression] autorelease];
}

+ (instancetype)expressionWithlogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression logicalOREperator:(NUCDecomposedPreprocessingToken *)aLogicalOROperator logicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression
{
    return [[[self alloc] initWithlogicalORExpression:aLogicalORExpression logicalOREperator:aLogicalOROperator logicalANDExpression:aLogicalANDExpression] autorelease];
}

- (instancetype)initWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;
{
    return [self initWithlogicalORExpression:nil logicalOREperator:nil logicalANDExpression:aLogicalANDExpression];
}

- (instancetype)initWithlogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression logicalOREperator:(NUCDecomposedPreprocessingToken *)aLogicalOROperator logicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;
{
    if (self = [super initWithType:NUCLexicalElementLogicalORExpressionType])
    {
        logicalORExpression = [aLogicalORExpression retain];
        logicalOROperator = [aLogicalOROperator retain];
        logicalANDExpression = [aLogicalANDExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [logicalORExpression release];
    [logicalOROperator release];
    [logicalANDExpression release];
    
    [super dealloc];
}

@end
