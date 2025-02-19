//
//  NUCTranslationUnit.h
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@class NSMutableArray;
@class NUCExternalDeclaration;

@interface NUCTranslationUnit : NUCExternalDefinition

@property (nonatomic, retain) NSMutableArray *externalDeclarations;

+ (BOOL)translationUnitFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCTranslationUnit **)aTranslationUnit;

- (void)add:(NUCExternalDeclaration *)anExternalDeclaration;

@end

