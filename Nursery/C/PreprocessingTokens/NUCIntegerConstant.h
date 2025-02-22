//
//  NUCIntegerConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/12.
//

#import "NUCPreprocessingToken.h"

@class NUCTokenStream, NUCConstant;

@interface NUCIntegerConstant : NUCPreprocessingToken
{
    id <NUCToken> ppNumber;
}

@property (nonatomic) NUUInt64 value;

+ (BOOL)integerConstantFrom:(NUCTokenStream *)aPreprocessingTokenStream into:(NUCConstant **)aConstant;

+ (BOOL)integerConstantFromPpNumber:(id <NUCToken>)aPpNumber into:(NUCConstant **)aConstant;

+ (instancetype)constantWithPpNumber:(id <NUCToken>)aPpNumber value:(NUUInt64)aValue;

- (instancetype)initWithPpNumber:(id <NUCToken>)aPpNumber value:(NUUInt64)aValue;

@end

