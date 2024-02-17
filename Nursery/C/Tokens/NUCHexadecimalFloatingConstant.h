//
//  NUCHexadecimalFloatingConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/17.
//  Copyright © 2024 com.lily-bud. All rights reserved.
//

#import "NUCFloatingConstant.h"

@class NUCHexadecimalFractionalConstant, NUCBinaryExponentPart;

@interface NUCHexadecimalFloatingConstant : NUCFloatingConstant

@property (nonatomic, copy) NSString *hexadecimalPrefix;
@property (nonatomic, retain) NUCHexadecimalFractionalConstant *hexadecimalFractionalConstant;
@property (nonatomic, copy) NSString *hexadecimalDigitSequence;
@property (nonatomic, retain) NUCBinaryExponentPart *binaryExponentPart;
@property (nonatomic, copy) NSString *floatingSuffix;

@end

