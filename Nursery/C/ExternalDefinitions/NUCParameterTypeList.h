//
//  NUCParameterTypeList.h
//  Nursery
//
//  Created by akiha on 2025/02/15.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@class NUCParameterList;
@protocol NUCToken;

@interface NUCParameterTypeList : NUCExternalDefinition

@property (nonatomic, retain) NUCParameterList *parameterList;
@property (nonatomic, retain) id <NUCToken> comma;
@property (nonatomic, retain) id <NUCToken> ellipsis;

+ (BOOL)parameterTypeListFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCParameterTypeList **)aParameterTypeList;

@end

