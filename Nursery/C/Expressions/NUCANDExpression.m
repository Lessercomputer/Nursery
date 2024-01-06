//
//  NUCANDExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCANDExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCEqualityExpression.h"

@implementation NUCANDExpression

+ (BOOL)andExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCANDExpression **)anExpression
{
    NUCEqualityExpression *anEqulityExpression = nil;
    
    if ([NUCEqualityExpression equalityExpressionFrom:aStream into:&anEqulityExpression])
    {
        if (anExpression)
            *anExpression = [NUCANDExpression expressionWithEqualityExpression:anEqulityExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCANDExpression *anANDExpression = nil;
        
        if ([self andExpressionFrom:aStream into:&anANDExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            NUCDecomposedPreprocessingToken *anAndOperator = [aStream next];
            
            if ([anAndOperator isBitwiseANDOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                NUCEqualityExpression *anEqulityExpression = nil;
                
                if ([NUCEqualityExpression equalityExpressionFrom:aStream into:&anEqulityExpression])
                {
                    if (anExpression)
                        *anExpression = [NUCANDExpression expressionWithANDExpression:anANDExpression andOperator:anAndOperator equlityExpression:anEqulityExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}

+ (instancetype)expressionWithEqualityExpression:(NUCEqualityExpression *)anEqulityExpression
{
    return [[[self alloc] initWithEqualityExpression:anEqulityExpression] autorelease];
}

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqualityExpression *)anEqulityExpression
{
    return [[[self alloc] initWithANDExpression:anANDExpression andOperator:anANDOperator equlityExpression:anEqulityExpression] autorelease];
}

- (instancetype)initWithEqualityExpression:(NUCEqualityExpression *)anEqulityExpression
{
    return [self initWithANDExpression:nil andOperator:nil equlityExpression:anEqulityExpression];
}

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqualityExpression *)anEqulityExpression
{
    if (self = [super initWithType:NUCExpressionANDExpressionType])
    {
        equlityExpression = [anEqulityExpression retain];
        andExpression = [anANDExpression retain];
        andOperator = [andOperator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [equlityExpression release];
    [andExpression release];
    [andOperator release];
    
    [super dealloc];
}

- (NUCExpressionResult *)executeWith:(NUCPreprocessor *)aPreprocessor
{
    return [equlityExpression executeWith:aPreprocessor];
}

@end
