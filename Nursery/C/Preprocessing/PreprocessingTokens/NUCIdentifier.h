//
//  NUCIdentifier.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/05/16.
//

#import "NUCDecomposedPreprocessingToken.h"


@interface NUCIdentifier : NUCDecomposedPreprocessingToken 

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange;

@end

