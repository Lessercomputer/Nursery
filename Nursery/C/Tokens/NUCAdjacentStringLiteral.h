//
//  NUCAdjacentStringLiteral.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//  Copyright © 2024 com.lily-bud. All rights reserved.
//

#import "NUCToken.h"


@interface NUCAdjacentStringLiteral : NUCToken

@property (nonatomic, copy) NSArray *stringLiterals;

+ (instancetype)adjacentStringLiteralWith:(NSArray *)aStringLiterals;

- (instancetype)initWithType:(NUCLexicalElementType)aType stringLiterals:(NSArray *)aStringLiterals;

@end

