//
//  NUCConstant.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/05.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCIntegerConstant, NUCDecomposedPreprocessingToken;

@interface NUCConstant : NUCPreprocessingToken
{
    NUCPreprocessingToken *content;
}

+ (instancetype)constantWithIntegerConstant:(NUCIntegerConstant *)anIntegerConstant;
+ (instancetype)constantWithCharacterConstant:(NUCDecomposedPreprocessingToken *)aCharacterConstant;

- (instancetype)initWithContent:(NUCPreprocessingToken *)aContent;

@end

