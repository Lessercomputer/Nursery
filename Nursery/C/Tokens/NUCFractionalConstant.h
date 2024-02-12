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

+ (instancetype)constantWithDigitSequence:(NSString *)aDigitSequence digitSequence2:(NSString *)aDigitSequence2;

- (instancetype)initWithType:(NUCLexicalElementType)aType digitSequence:(NSString *)aDigitSequence digitSequence2:(NSString *)aDigitSequence2;

@end

