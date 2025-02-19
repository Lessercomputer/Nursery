//
//  NUCParameterList.h
//  Nursery
//
//  Created by akiha on 2025/02/15.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@class NSMutableArray, NUCParameterDeclaration;

@interface NUCParameterList : NUCExternalDefinition

@property (nonatomic, retain) NSMutableArray *parameterDeclarations;

+ (BOOL)parameterListFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCParameterList **)aParameterList;

- (void)add:(NUCParameterDeclaration *)aParameterDeclaration;

@end

