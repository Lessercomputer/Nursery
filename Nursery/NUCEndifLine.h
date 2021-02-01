//
//  NUCEndifLine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPreprocessingToken, NUCNewline;

@interface NUCEndifLine : NUCPreprocessingDirective
{
    NUCPreprocessingToken *hash;
    NUCPreprocessingToken *endif;
    NUCNewline *newline;
}

+ (instancetype)endifLineWithHash:(NUCPreprocessingToken *)aHash endif:(NUCPreprocessingToken *)anEndif newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCPreprocessingToken *)aHash endif:(NUCPreprocessingToken *)anEndif newline:(NUCNewline *)aNewline;

- (NUCPreprocessingToken *)hash;
- (NUCPreprocessingToken *)endif;
- (NUCNewline *)newline;

@end

