//
//  NUCControlLine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCDecomposedPreprocessingToken, NUCNewline;

@interface NUCControlLine : NUCPreprocessingDirective
{
    NUCDecomposedPreprocessingToken *hash;
    NUCDecomposedPreprocessingToken *directiveName;
    NUCNewline *newline;
}

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName newline:(NUCNewline *)aNewline;

- (NUCDecomposedPreprocessingToken *)hash;
- (NUCDecomposedPreprocessingToken *)directiveName;
- (NUCNewline *)newline;

@end

