//
//  NUCExternalDeclaration.h
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@class NSMutableArray;

@interface NUCExternalDeclaration : NUCExternalDefinition

@property (nonatomic, retain) NSMutableArray *externalDeclarations;

+ (BOOL)externalDeclarationFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCExternalDeclaration **)anExternalDeclaration;

- (void)add:(NUCExternalDefinition *)anExternalDeclation;

@end

