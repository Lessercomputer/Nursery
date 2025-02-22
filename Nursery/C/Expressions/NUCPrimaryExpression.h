//
//  NUCPrimaryExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCProtoExpression.h"

@class NUCTokenStream, NUCConstant, NUCExpression;

@interface NUCPrimaryExpression : NUCProtoExpression
{
    id content;
}

+ (BOOL)primaryExpressionFrom:(NUCTokenStream *)aStream into:(NUCPrimaryExpression **)anExpression;

+ (instancetype)expressionWithIdentifier:(id <NUCToken>)anIdentifier;
+ (instancetype)expressionWithConstant:(NUCConstant *)aConstant;
+ (instancetype)expressionWithStringLiteral:(id <NUCToken>)aStringLiteral;
+ (instancetype)expressionWithExpression:(NUCExpression *)anExpression;

- (instancetype)initWithContent:(id)aContent;

@end

