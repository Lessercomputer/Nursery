//
//  NUCFloatingConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCLexicalElement.h"

@class NUCDecomposedPreprocessingToken, NUCConstant;

@interface NUCFloatingConstant : NUCLexicalElement

+ (BOOL)signFrom:(NSString *)aString into:(NSString **)aSign location:(NSUInteger *)aLocationPointer;
+ (BOOL)digitSequenceFrom:(NSString *)aString at:(NSUInteger *)aLocation into:(NSString **)aDigitSequence;

+ (BOOL)floatingConstantFromPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber into:(NUCConstant **)aConstant;

@end

