//
//  NUCDirectDeclarator.h
//  Nursery
//
//  Created by akiha on 2025/02/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@protocol NUCToken;
@class NUCParameterTypeList;

@interface NUCDirectDeclarator : NUCExternalDefinition

+ (BOOL)directDeclaratorFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCDirectDeclarator **)aDirectDeclarator;

@property (nonatomic, retain) id <NUCToken> identifier;
@property (nonatomic, retain) id <NUCToken> directDeclarator;
@property (nonatomic, retain) id <NUCToken> openingPunctuator;
@property (nonatomic, retain) id <NUCToken> closingPunctuator;

@property (nonatomic, retain) NUCParameterTypeList *parameterTypeList;

@end

