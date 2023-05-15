//
//  NUCNewline.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPreprocessingTokenStream;

@interface NUCNewline : NUCPreprocessingDirective
{
    NUCLexicalElement *cr;
    NUCLexicalElement *lf;
}

+ (BOOL)newlineFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCNewline **)aNewline;

+ (instancetype)newlineWithCr:(NUCLexicalElement *)aCr lf:(NUCLexicalElement *)aLf;

- (instancetype)initWithCr:(NUCLexicalElement *)aCr lf:(NUCLexicalElement *)aLf;

- (BOOL)isCr;
- (BOOL)isLf;
- (BOOL)isCrLf;

- (NUCLexicalElement *)cr;
- (NUCLexicalElement *)lf;

@end
