//
//  NUCConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/05.
//

#import "NUCPreprocessingToken.h"

@class NUCIntegerConstant, NUCDecomposedPreprocessingToken;

@interface NUCConstant : NUCPreprocessingToken
{
    NUCPreprocessingToken *content;
}

+ (BOOL)constantFrom:(NUCDecomposedPreprocessingToken *)aStream into:(NUCConstant **)aConstant;

+ (instancetype)constantWithIntegerConstant:(NUCIntegerConstant *)anIntegerConstant;
+ (instancetype)constantWithCharacterConstant:(NUCDecomposedPreprocessingToken *)aCharacterConstant;

- (instancetype)initWithContent:(NUCPreprocessingToken *)aContent;

@end

