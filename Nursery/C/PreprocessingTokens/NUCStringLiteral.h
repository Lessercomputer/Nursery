//
//  NUCStringLiteral.h
//  Nursery
//
//  Created by aki on 2023/05/24.
//

#import "NUCDecomposedPreprocessingToken.h"

@interface NUCStringLiteral : NUCDecomposedPreprocessingToken
{
    NSString *encodingPrefix;
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aString range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix;

- (NSString *)encodingPrefix;

+ (NSString *)escapeStringForStringLiteral:(NSString *)aString;

@end

