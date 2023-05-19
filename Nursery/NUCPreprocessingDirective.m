//
//  NUCPreprocessingDirective.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@implementation NUCPreprocessingDirective

- (BOOL)isPpTokens
{
    return [self type] == NUCLexicalElementPpTokensType;
}

- (BOOL)isControlLine
{
    return [self type] == NUCLexicalElementControlLineType;
}

@end
