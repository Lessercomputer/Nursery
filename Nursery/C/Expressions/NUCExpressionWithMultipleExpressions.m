//
//  NUCExpressionWithMultipleExpressions.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/25.
//

#import "NUCExpressionWithMultipleExpressions.h"
#import "NUCPreprocessingTokenStream.h"

@implementation NUCExpressionWithMultipleExpressions

@synthesize expressions, operators;

+ (instancetype)expression
{
    return [[[self alloc] init] autorelease];
}

+ (BOOL)expressionInto:(NUCProtoExpression **)anExpression from:(NUCPreprocessingTokenStream *)aStream
{
    NUCExpressionWithMultipleExpressions *anExpressionToReturn = [self expression];
    
    while (YES)
    {
        NUCProtoExpression *aSubexpression = nil;
        
        if ([self subexpressionInto:&aSubexpression from:aStream])
        {
            NSUInteger aPosition = [aStream position];
            
            [anExpressionToReturn add:aSubexpression];
            
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aStream next];
            
            if ([self operatorIsValid:anOperator])
            {
                [anExpressionToReturn addOperator:anOperator];
                [aStream skipWhitespacesWithoutNewline];
            }
            else
            {
                [aStream setPosition:aPosition];
                
                if (anExpression)
                    *anExpression = anExpressionToReturn;
                
                return YES;
            }
        }
        else
            return NO;
    }
}

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCPreprocessingTokenStream *)aStream
{
    return NO;
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return NO;
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
