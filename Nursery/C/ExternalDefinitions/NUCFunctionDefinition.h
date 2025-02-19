//
//  NUCFunctionDefinition.h
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@class NUCDeclarationSpecifiers, NUCDeclarator;

@interface NUCFunctionDefinition : NUCExternalDefinition

+ (BOOL)functionDefinitionFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCFunctionDefinition **)aFunctionDefinition;

@property (nonatomic, retain) NUCDeclarationSpecifiers *declarationSpecifiers;
@property (nonatomic, retain) NUCDeclarator *declarator;

@end

