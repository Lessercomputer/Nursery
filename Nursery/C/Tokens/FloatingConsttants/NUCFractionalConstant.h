//
//  NUCFractionalConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCToken.h"


@interface NUCFractionalConstant : NUCToken

@property (nonatomic, copy) NSString *digitSequence;
@property (nonatomic, copy) NSString *digitSequence2;

+ (BOOL)fractionalConstantFrom:(NSString *)aString into:(NSString **)aDigitSequence into:(NSString  **)aDigitSequence2 location:(NSUInteger *)aLocationPointer;

+ (NSCharacterSet *)digitSequenceCharacterSet;

+ (instancetype)constantWithDigitSequence:(NSString *)aDigitSequence digitSequence2:(NSString *)aDigitSequence2;

- (instancetype)initWithType:(NUCLexicalElementType)aType digitSequence:(NSString *)aDigitSequence digitSequence2:(NSString *)aDigitSequence2;

@end

