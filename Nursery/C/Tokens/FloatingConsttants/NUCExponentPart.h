//
//  NUCExponentPart.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCToken.h"


@interface NUCExponentPart : NUCToken

@property (nonatomic, readonly) NSString *smallEOrLargeE;
@property (nonatomic, copy) NSString *eOrP;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *digitSequence;

+ (BOOL)expornentPartFrom:(NSString *)aString into:(NSString **)anEOrP into:(NSString **)aSign into:(NSString **)aDigitSequence location:(NSUInteger *)aLocationPointer;

+ (BOOL)eOrPFrom:(NSString *)aString into:(NSString **)aSmallPOrLargeP location:(NSUInteger *)aLocationPointer;

+ (instancetype)exponentPartWith:(NSString *)aString location:(NSUInteger *)aLocationPointer;

+ (instancetype)exponentPartWithEOrP:(NSString *)anEOrP sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence;

- (instancetype)initWithType:(NUCLexicalElementType)aType eOrP:(NSString *)aSmallEOrLargeE sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence;

@end

