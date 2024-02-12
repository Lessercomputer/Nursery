//
//  NUCFloatingConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCLexicalElement.h"

@class NUCDecomposedPreprocessingToken, NUCConstant;

@interface NUCFloatingConstant : NUCLexicalElement

+ (BOOL)floatingConstantFromPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber into:(NUCConstant **)aConstant;

@end

