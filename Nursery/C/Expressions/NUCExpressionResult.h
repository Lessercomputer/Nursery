//
//  NUCExpressionResult.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/06.
//

#import <Foundation/NSObject.h>


@interface NUCExpressionResult : NSObject
{
    NSInteger intValue;
}

- (instancetype)initWithIntValue:(NSInteger)aValue;

- (NSInteger)intValue;

@end

