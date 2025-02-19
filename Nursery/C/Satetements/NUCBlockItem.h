//
//  NUCBlockItem.h
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCSyntaxElement.h"

@class NUCPreprocessingTokenToTokenStream;
@class NUCStatement;

@interface NUCBlockItem : NUCSyntaxElement

@property (nonatomic, retain) NUCStatement *statement;

+ (BOOL)blockItemFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCBlockItem **)aBlockItem;

@end

