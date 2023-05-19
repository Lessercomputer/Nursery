//
//  NUCIdentifier.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/05/16.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCDecomposedPreprocessingToken.h"


@interface NUCIdentifier : NUCDecomposedPreprocessingToken <NSCopying>

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange;

@end

