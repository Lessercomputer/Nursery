//
//  NUCExpressionWithMultipleExpressions.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/25.
//

#import "NUCExpressionWithMultipleExpressions.h"

@implementation NUCExpressionWithMultipleExpressions

@synthesize expressions;

+ (instancetype)expression
{
    return [[[self alloc] init] autorelease];
}

- (instancetype)initWithType:(NUCExpressionType)aType
{
    if (self = [super initWithType:aType])
    {
        expressions = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [expressions release];
    
    [super dealloc];
}

- (void)add:(NUCProtoExpression *)anExpression
{
    [[self expressions] addObject:anExpression];
}

- (NUUInt64)count
{
    return [[self expressions] count];
}

@end
