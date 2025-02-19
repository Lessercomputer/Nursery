//
//  NUCParameterDeclaration.h
//  Nursery
//
//  Created by akiha on 2025/02/15.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@class NUCDeclarationSpecifiers, NUCDeclarator;

@interface NUCParameterDeclaration : NUCExternalDefinition

+ (BOOL)parameterDeclarationFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCParameterDeclaration **)aParameterDeclaration;

@property (nonatomic, retain) NUCDeclarationSpecifiers *declarationSpecifiers;
@property (nonatomic, retain) NUCDeclarator *declartor;

@end

