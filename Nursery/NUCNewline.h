//
//  NUCNewline.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@interface NUCNewline : NUCPreprocessingDirective
{
    NUCLexicalElement *cr;
    NUCLexicalElement *lf;
}


+ (instancetype)newlineWithCr:(NUCLexicalElement *)aCr lf:(NUCLexicalElement *)aLf;

- (instancetype)initWithCr:(NUCLexicalElement *)aCr lf:(NUCLexicalElement *)aLf;

- (BOOL)isCr;
- (BOOL)isLf;
- (BOOL)isCrLf;

- (NUCLexicalElement *)cr;
- (NUCLexicalElement *)lf;

@end
