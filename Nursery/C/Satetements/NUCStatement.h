//
//  NUCStatement.h
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCSyntaxElement.h"

@class NUCPreprocessingTokenToTokenStream;

@interface NUCStatement : NUCSyntaxElement

@property (nonatomic, retain) NUCSyntaxElement *statement;

+ (BOOL)statementFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCStatement **)aStatement;

@end

