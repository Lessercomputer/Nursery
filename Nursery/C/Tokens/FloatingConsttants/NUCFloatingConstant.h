//
//  NUCFloatingConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCLexicalElement.h"

@class NUCDecomposedPreprocessingToken, NUCConstant;

@interface NUCFloatingConstant : NUCLexicalElement

@property (nonatomic, retain) NUCDecomposedPreprocessingToken *ppNumber;

+ (BOOL)signFrom:(NSString *)aString into:(NSString **)aSign location:(NSUInteger *)aLocationPointer;
+ (BOOL)digitSequenceFrom:(NSString *)aString at:(NSUInteger *)aLocation into:(NSString **)aDigitSequence;
+ (BOOL)floatingSuffixFrom:(NSString *)aString into:(NSString **)aFloatingSuffix location:(NSUInteger *)aLocationPointer;

+ (BOOL)floatingConstantFromPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber into:(NUCConstant **)aConstant;

- (instancetype)initWithType:(NUCLexicalElementType)aType ppNumber:(NUCDecomposedPreprocessingToken *)aPpNumber;

@end

