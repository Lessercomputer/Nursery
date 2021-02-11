//
//  NUCIdentifierList.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCLexicalElement.h"


@interface NUCIdentifierList : NUCLexicalElement
{
    NSMutableArray *identifiers;
}

+ (instancetype)identifierList;

- (void)add:(NUCLexicalElement *)anIdentifier;
- (NSMutableArray *)identifiers;
- (NSUInteger)count;

@end

