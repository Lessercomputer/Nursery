//
//  NUCConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/05.
//

#import "NUCPreprocessingToken.h"

@class NUCIntegerConstant, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCConstant : NUCPreprocessingToken

@property (nonatomic, retain) NUCPreprocessingToken *content;

+ (BOOL)constantFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCConstant **)aConstant;

+ (instancetype)constantWithIntegerConstant:(NUCIntegerConstant *)anIntegerConstant;
+ (instancetype)constantWithCharacterConstant:(NUCDecomposedPreprocessingToken *)aCharacterConstant;

- (instancetype)initWithContent:(NUCPreprocessingToken *)aContent;

@end

