//
//  NUCKeyword.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCToken.h"


@interface NUCKeyword : NUCToken

@property (nonatomic, retain) NUCDecomposedPreprocessingToken *identifier;

@property (nonatomic, readonly) BOOL isVoid;
@property (nonatomic, readonly) BOOL isInt;

+ (instancetype)tokenWith:(NUCDecomposedPreprocessingToken *)aPpToken;

@end

