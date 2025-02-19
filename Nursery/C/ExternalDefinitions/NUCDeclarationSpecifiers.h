//
//  NUCDeclarationSpecifiers.h
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDeclaration.h"


@interface NUCDeclarationSpecifiers : NUCExternalDeclaration

+ (BOOL)declarationSpecifiersFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCDeclarationSpecifiers **)aDeclarationSpecifiers;

@property (nonatomic, retain) NSMutableArray *specifiers;
@property (nonatomic, readonly) NSUInteger count;

- (void)add:(NUCExternalDefinition *)anExternalDefinition;

@end

