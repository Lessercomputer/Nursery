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

@end
