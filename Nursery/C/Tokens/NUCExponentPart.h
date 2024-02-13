//
//  NUCExponentPart.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCToken.h"


@interface NUCExponentPart : NUCToken

@property (nonatomic, copy) NSString *smallEOrLargeE;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *digitSequence;

+ (BOOL)expornentPartFrom:(NSString *)aString into:(NSString **)aSmallEOrLargeE into:(NSString **)aSign into:(NSString **)aDigitSequence location:(NSUInteger *)aLocationPointer;

+ (instancetype)exponentPartWith:(NSString *)aString location:(NSUInteger *)aLocationPointer;

+ (instancetype)exponentPartWithSmallEOrLargeE:(NSString *)aSmallEOrLargeE sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence;

- (instancetype)initWithType:(NUCLexicalElementType)aType smallEOrLargeE:(NSString *)aSmallEOrLargeE sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence;

@end

