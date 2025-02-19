//
//  NUCDeclarator.h
//  Nursery
//
//  Created by akiha on 2025/02/05.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@class NUCDirectDeclarator;

@interface NUCDeclarator : NUCExternalDefinition

+ (BOOL)declaratorFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCDeclarator **)aDeclarator;

@property (nonatomic, retain) id pointer;
@property (nonatomic, retain) NUCDirectDeclarator *directDeclarator;

@end

