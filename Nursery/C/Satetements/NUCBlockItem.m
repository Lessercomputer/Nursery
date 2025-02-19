//
//  NUCBlockItem.m
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCBlockItem.h"
#import "NUCStatement.h"

@implementation NUCBlockItem

+ (BOOL)blockItemFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCBlockItem **)aBlockItem
{
    NUCBlockItem *aBlockItemToReturn = [[self new] autorelease];
    NUCStatement *aStatement = nil;
    
    if ([NUCStatement statementFrom:aStream into:&aStatement])
        [aBlockItemToReturn setStatement:aStatement];
    else
        return NO;
    
    if (aBlockItem)
        *aBlockItem = aBlockItemToReturn;
    return YES;
}

@end
