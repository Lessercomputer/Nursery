//
//  NUCExpressionWithMultipleExpressions.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/25.
//

#import "NUCExpressionWithMultipleExpressions.h"

@implementation NUCExpressionWithMultipleExpressions

@synthesize expressions, operators;

+ (instancetype)expression
{
    return [[[self alloc] init] autorelease];
}

- (instancetype)initWithType:(NUCExpressionType)aType
{
    if (self = [super initWithType:aType])
    {
        expressions = [NSMutableArray new];
        operators = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [expressions release];
    [operators release];
    
    [super dealloc];
}

- (void)add:(NUCProtoExpression *)anExpression
{
    [[self expressions] addObject:anExpression];
}

- (NUCProtoExpression *)at:(NSUInteger)anIndex
{
    return [[self expressions] objectAtIndex:anIndex];
}

- (NUUInt64)count
{
    return [[self expressions] count];
}

- (void)addOperator:(NUCDecomposedPreprocessingToken *)anOperator
{
    [[self operators] addObject:anOperator];
}

- (NUCDecomposedPreprocessingToken *)operatorAt:(NSUInteger)anIndex
{
    return [[self operators] objectAtIndex:anIndex];
}

-(NUUInt64)operatorCount
{
    return [[self operators] count];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor using:(void (^)(NUCExpressionResult *aLeftExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *aRightExpressionResult, NUCExpressionResult **aBinaryExpressionResult))aBlock
{
    NSMutableArray *anExpressionResults = [NSMutableArray array];
    
    [[self expressions] enumerateObjectsUsingBlock:^(id  _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        [anExpressionResults addObject:[anExpression evaluateWith:aPreprocessor]];
    }];
        
    NUCExpressionResult *aPreviousExpressionResult = [anExpressionResults firstObject];
    
    for (NSUInteger anIndex = 1; anIndex < [anExpressionResults count]; anIndex++)
    {
        aBlock(aPreviousExpressionResult, [self operatorAt:anIndex - 1], [anExpressionResults objectAtIndex:anIndex], &aPreviousExpressionResult);
    }
    
    return aPreviousExpressionResult;
}

@end
