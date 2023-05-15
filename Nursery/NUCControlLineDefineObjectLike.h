//
//  NUCControlLineDefineObjectLike.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLineDefine.h"


@interface NUCControlLineDefineObjectLike : NUCControlLineDefine

+ (BOOL)controlLineDefineObjectLikeFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier into:(NUCPreprocessingDirective **)aToken;

@end

