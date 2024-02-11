//
//  NUCIntegerConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/12.
//

#import "NUCPreprocessingToken.h"

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream, NUCConstant;

@interface NUCIntegerConstant : NUCPreprocessingToken
{
    NUCDecomposedPreprocessingToken *ppNumber;
}

@property (nonatomic) NUUInt64 value;

+ (BOOL)integerConstantFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCConstant **)aConstant;

+ (BOOL)integerConstantFromPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber into:(NUCConstant **)aConstant;

+ (instancetype)constantWithPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber value:(NUUInt64)aValue;

- (instancetype)initWithPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber value:(NUUInt64)aValue;

@end

