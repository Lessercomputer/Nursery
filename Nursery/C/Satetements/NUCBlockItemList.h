//
//  NUCBlockItemList.h
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCSyntaxElement.h"

@class NUCPreprocessingTokenToTokenStream, NUCBlockItem;
@class NSMutableArray;

@interface NUCBlockItemList : NUCSyntaxElement

@property (nonatomic, retain) NSMutableArray *list;

+ (BOOL)blockItemListFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCBlockItemList **)aBlockItemList;

- (void)add:(NUCBlockItem *)aBlockItem;

@end

