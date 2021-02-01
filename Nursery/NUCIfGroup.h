//
//  NUCIfGroup.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPreprocessingToken, NUCGroup;

@interface NUCIfGroup : NUCPreprocessingDirective
{
    NUCPreprocessingToken *hash;
    NUCLexicalElement *expressionOrIdentifier;
    NUCPreprocessingDirective *newline;
    NUCGroup *group;
}

+ (instancetype)ifGroupWithType:(NUCLexicalElementType)aType hash:(NUCPreprocessingToken *)aHash expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup;

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCPreprocessingToken *)aHash expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup;

- (BOOL)isIf;
- (BOOL)isIfdef;
- (BOOL)isIfndef;

- (NUCPreprocessingToken *)hash;
- (NUCLexicalElement *)expression;
- (NUCLexicalElement *)identifier;
- (NUCPreprocessingDirective *)newline;
- (NUCGroup *)group;

@end
