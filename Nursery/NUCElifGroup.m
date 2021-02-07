//
//  NUCElifGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCElifGroup.h"

@implementation NUCElifGroup

+ (instancetype)elifGroupWithType:(NUCLexicalElementType)aType hash:(NUCPreprocessingToken *)aHash directiveName:(NUCPreprocessingToken *)anElif expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithType:aType hash:aHash directiveName:anElif expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup] autorelease];
}

@end
