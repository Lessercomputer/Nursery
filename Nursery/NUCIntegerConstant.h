//
//  NUCIntegerConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/12.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream, NUCConstant;

@interface NUCIntegerConstant : NUCPreprocessingToken
{
    NUCDecomposedPreprocessingToken *ppNumber;
    NUUInt64 value;
}

+ (BOOL)integerConstantFrom:(NUCDecomposedPreprocessingToken *)aPreprocessingToken into:(NUCConstant **)aConstant;

+ (instancetype)constantWithPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber value:(NUUInt64)aValue;

- (instancetype)initWithPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber value:(NUUInt64)aValue;

@end

