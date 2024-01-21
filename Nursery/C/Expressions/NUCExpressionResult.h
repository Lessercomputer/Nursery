//
//  NUCExpressionResult.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/06.
//

#import <Foundation/NSObject.h>


@interface NUCExpressionResult : NSObject
{
    int intValue;
}

+ (instancetype)expressionResultWithIntValue:(int)aValue;

- (instancetype)initWithIntValue:(int)aValue;

- (int)intValue;

@end

