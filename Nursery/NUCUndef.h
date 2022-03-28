//
//  NUCUndef.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/11/18.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCControlLine.h"

@interface NUCUndef : NUCControlLine
{
    NUCPreprocessingToken *identifier;
}

+ (instancetype)undefWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCPreprocessingToken *)anIdentifier newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCPreprocessingToken *)anIdentifier newline:(NUCNewline *)aNewline;

- (NUCPreprocessingToken *)identifier;

@end

