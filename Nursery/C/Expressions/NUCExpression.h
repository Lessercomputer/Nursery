//
//  NUCExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import <Foundation/NSObject.h>

@class NUCConditionalExpression, NUCPreprocessingTokenStream;

@interface NUCExpression : NSObject
{
    NUCConditionalExpression *conditionalExpression;
}

+ (BOOL)expressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCExpression **)aToken;

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)aConditionalExpression;

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)aConditionalExpression;

@end

