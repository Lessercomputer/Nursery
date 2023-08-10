//
//  NUCCharacterConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/08/10.
//

#import "NUCDecomposedPreprocessingToken.h"


@interface NUCCharacterConstant : NUCDecomposedPreprocessingToken
{
    NSString *encodingPrefix;
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aString range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix;

- (NSString *)encodingPrefix;

@end

