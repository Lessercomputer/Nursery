//
//  NUCControlLineDefineObjectLike.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//

#import "NUCControlLineDefine.h"


@interface NUCControlLineDefineObjectLike : NUCControlLineDefine

+ (BOOL)controlLineDefineObjectLikeFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier into:(NUCPreprocessingDirective **)aToken;

@end

