//
//  NUCConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/05.
//

#import "NUCPreprocessingToken.h"

@class NUCIntegerConstant, NUCCharacterConstant, NUCPreprocessingTokenStream, NUCDecomposedPreprocessingToken;

@interface NUCConstant : NUCPreprocessingToken

@property (nonatomic, retain) NUCPreprocessingToken *content;

+ (BOOL)constantFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCConstant **)aConstant;

+ (instancetype)constantFromPpToken:(NUCDecomposedPreprocessingToken *)aPpToken;

+ (instancetype)constantWithIntegerConstant:(NUCIntegerConstant *)anIntegerConstant;
+ (instancetype)constantWithCharacterConstant:(NUCCharacterConstant *)aCharacterConstant;

- (instancetype)initWithContent:(NUCPreprocessingToken *)aContent;

@end

