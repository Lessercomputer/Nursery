//
//  NUCDecimalFloatingConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCFloatingConstant.h"

@class NUCFractionalConstant, NUCExponentPart;

@interface NUCDecimalFloatingConstant : NUCFloatingConstant

@property (nonatomic, retain) NUCFractionalConstant *fractionalConstant;
@property (nonatomic, retain) NUCExponentPart *exponentPart;
@property (nonatomic, copy) NSString *floatingSuffix;

+ (instancetype)floatingConstantWithFractionalConstant:(NUCFractionalConstant *)aFractionalConstant exponentPart:(NUCExponentPart *)anExponentPart floatingSuffix:(NSString *)aFloatingSuffix;

@end

