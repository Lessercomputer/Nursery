//
//  NUCConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/05.
//

#import "NUCPreprocessingToken.h"

@class NUCIntegerConstant, NUCCharacterConstant, NUCPreprocessingTokenStream, NUCDecomposedPreprocessingToken, NUCFloatingConstant;

@interface NUCConstant : NUCPreprocessingToken

@property (nonatomic, retain) id <NUCToken>content;

+ (BOOL)constantFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCConstant **)aConstant;

+ (instancetype)constantFromPpToken:(NUCDecomposedPreprocessingToken *)aPpToken;

+ (instancetype)constantWithIntegerConstant:(NUCIntegerConstant *)anIntegerConstant;
+ (instancetype)constantWithFloatingConstant:(NUCFloatingConstant *)aFloatingConstant;
+ (instancetype)constantWithCharacterConstant:(NUCCharacterConstant *)aCharacterConstant;

- (instancetype)initWithContent:(id <NUCToken>)aContent;

@end

