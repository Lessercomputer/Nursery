//
//  NUCPreprocessingToken.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCLexicalElement.h"

@class NUCPreprocessor;

@interface NUCPreprocessingToken : NUCLexicalElement
{
    NSArray *macroExpandedPpTokens;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor;

- (NSArray *)macroExpandedPpTokens;
- (void)setMacroExpandedPpTokens:(NSArray *)aMacroExpandedPpTokens;

@end

