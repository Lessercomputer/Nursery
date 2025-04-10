//
//  NUCCompoundStatement.m
//  Nursery
//
//  Created by akiha on 2025/02/16.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCCompoundStatement.h"
#import "NUCBlockItemList.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCTokenProtocol.h"
#import "NUCTranslationOrderMap.h"

@implementation NUCCompoundStatement

+ (BOOL)compoundStatementFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCCompoundStatement **)aCompoundStatement
{
    NUCCompoundStatement *aCompoundStatementToReturn = [[self new] autorelease];
    NUCBlockItemList *aBlockItemList = nil;
    
    NSUInteger aPosition = [aStream position];
    id <NUCToken> aToken = [aStream next];
    
    if ([aToken isOpeningBrace])
    {
        if ([NUCBlockItemList blockItemListFrom:aStream into:&aBlockItemList])
            [aCompoundStatementToReturn setBlockItemList:aBlockItemList];
        
        id <NUCToken> aToken = [aStream next];
        if ([aToken isClosingBrace])
        {
            if (aCompoundStatement)
                *aCompoundStatement = aCompoundStatementToReturn;
            return YES;
        }
    }
    
    [aStream setPosition:aPosition];
    return NO;
}

- (void)dealloc
{
    [_blockItemList release];
    [super dealloc];
}

- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent depth:(NUUInt64)aDepth
{
    [aMap add:self parent:aParent depth:aDepth];
    [[self blockItemList] mapTo:aMap parent:self depth:aDepth + 1];
}

@end
