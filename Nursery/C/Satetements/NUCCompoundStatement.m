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

@end
