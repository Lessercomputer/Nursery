//
//  NUCElifGroup.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCIfGroup.h"

@interface NUCElifGroup : NUCIfGroup

+ (BOOL)elifGroupFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCElifGroup **)anElifGroup;

+ (instancetype)elifGroupWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)anElif expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup;

@end
