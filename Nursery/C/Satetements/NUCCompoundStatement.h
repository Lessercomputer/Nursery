//
//  NUCCompoundStatement.h
//  Nursery
//
//  Created by akiha on 2025/02/16.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCSyntaxElement.h"

@class NUCPreprocessingTokenToTokenStream;
@class NUCBlockItemList;

@interface NUCCompoundStatement : NUCSyntaxElement

@property (nonatomic, retain) NUCBlockItemList *blockItemList;

+ (BOOL)compoundStatementFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCCompoundStatement **)aCompoundStatement;

@end

