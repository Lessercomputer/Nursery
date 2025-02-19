//
//  NUCJumpStatement.h
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCSyntaxElement.h"

@class NUCPreprocessingTokenToTokenStream;
@class NUCKeyword;
@class NUCExpression;

@interface NUCJumpStatement : NUCSyntaxElement

@property (nonatomic, retain) NUCKeyword *keyword;
@property (nonatomic, retain) NUCExpression *expression;

+ (BOOL)jumpStatementFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCJumpStatement **)aStatement;

@end

