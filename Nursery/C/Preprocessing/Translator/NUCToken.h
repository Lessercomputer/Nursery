//
//  NUCToken.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCLexicalElement.h"

@class NUCDecomposedPreprocessingToken;

@interface NUCToken : NUCLexicalElement

+ (BOOL)ppTokenIsKeyword:(NUCDecomposedPreprocessingToken *)aPpToken;

@end

