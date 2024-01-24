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
#import "NUCExpressionResult.h"

#import <Foundation/NSArray.h>

@implementation NUCLogicalORExpression

+ (BOOL)logicalORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalORExpression **)anExpression
{
    NUCLogicalORExpression *aLogicalORExpression = [self expression];
    
    while (YES)
    {
        NUCLogicalANDExpression *aLogicalANDExpression = nil;

        if ([NUCLogicalANDExpression logicalANDExpressionFrom:aStream into:&aLogicalANDExpression])
        {
            NSUInteger aPosition = [aStream position];
            
            [aLogicalORExpression add:aLogicalANDExpression];
            
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOROperator = [aStream next];
            
            if ([anOROperator isLogicalOROperator])
            {
                [aStream skipWhitespacesWithoutNewline];
            }
            else
            {
                [aStream setPosition:aPosition];
                
                if (anExpression)
                    *anExpression = aLogicalORExpression;
                
                return YES;
            }
        }
        else
            return NO;
    }
}

+ (instancetype)expression
{
    return [[[self alloc] initWithType:NUCExpressionLogicalORExpressionType] autorelease];
}

- (instancetype)initWithType:(NUCExpressionType)aType
{
    if (self = [super initWithType:NUCExpressionLogicalORExpressionType])
    {
        _expressions = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [_expressions release];
    
    [super dealloc];
}

- (void)add:(NUCLogicalANDExpression *)anExpression
{
    [[self expressions] addObject:anExpression];
}

- (NUUInt64)count
{
    return [[self expressions] count];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    __block NUCExpressionResult *anExpressionResultToReturn = nil;
    
    [[self expressions] enumerateObjectsUsingBlock:^(id  _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NUCExpressionResult *anExpressionResult = [[anExpression evaluateWith:aPreprocessor] retain];
        if ([anExpressionResult intValue])
        {
            *stop = YES;
            anExpressionResultToReturn = anExpressionResult;
        }
    }];
    
    [anExpressionResultToReturn autorelease];
    
    return anExpressionResultToReturn ? anExpressionResultToReturn : [NUCExpressionResult expressionResultWithIntValue:0];
}

@end
