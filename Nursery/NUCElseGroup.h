//
//  NUCElseGroup.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPreprocessingToken, NUCNewline, NUCGroup;

@interface NUCElseGroup : NUCPreprocessingDirective
{
    NUCPreprocessingToken *hash;
    NUCPreprocessingToken *directiveName;
    NUCNewline *newline;
    NUCGroup *group;
}

+ (instancetype)elseGroupWithHash:(NUCPreprocessingToken *)aHash directiveName:(NUCPreprocessingToken *)anElse newline:(NUCNewline *)aNewline group:(NUCGroup *)aGroup;

- (instancetype)initWithHash:(NUCPreprocessingToken *)aHash directiveName:(NUCPreprocessingToken *)anElse newline:(NUCNewline *)aNewline group:(NUCGroup *)aGroup;

- (NUCPreprocessingToken *)hash;
- (NUCPreprocessingToken *)else;
- (NUCNewline *)newline;
- (NUCGroup *)group;

@end
