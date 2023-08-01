//
//  NUCStringLiteral.h
//  Nursery
//
//  Created by aki on 2023/05/24.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCDecomposedPreprocessingToken.h"

@interface NUCStringLiteral : NUCDecomposedPreprocessingToken
{
    NSString *encodingPrefix;
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aString range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange encodingPrefix:(NSString *)anEncodingPrefix;

- (NSString *)encodingPrefix;

@end

