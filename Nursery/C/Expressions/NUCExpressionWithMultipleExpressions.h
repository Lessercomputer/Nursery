//
//  NUCExpressionWithMultipleExpressions.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/25.
//

#import "NUCProtoExpression.h"
#import "NUTypes.h"

#import <Foundation/NSArray.h>

@interface NUCExpressionWithMultipleExpressions : NUCProtoExpression

@property (nonatomic, retain) NSMutableArray *expressions;
@property (nonatomic, readonly) NUUInt64 count;

+ (instancetype)expression;

- (void)add:(NUCProtoExpression *)anExpression;

@end

