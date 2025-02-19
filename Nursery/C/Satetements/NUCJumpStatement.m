//
//  NUCJumpStatement.m
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCJumpStatement.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCExpression.h"

@implementation NUCJumpStatement

+ (BOOL)jumpStatementFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCJumpStatement **)aJumpStatement
{
    NUCJumpStatement *aJumpStatementToReturn = [[self new] autorelease];
    NSUInteger aPosition = [aStream position];
    id <NUCToken> aToken = [aStream next];
    
    if ([aToken isKeyword])
    {
        [aJumpStatementToReturn setKeyword:(NUCKeyword *)aToken];
        
        NUCExpression *anExpression = nil;
        if ([NUCExpression expressionFrom:aStream into:&anExpression])
        {
            [aJumpStatementToReturn setExpression:anExpression];
            
        }
        
        aToken = [aStream next];
        if ([aToken isPunctuator])
        {
            if (aJumpStatement)
                *aJumpStatement = aJumpStatementToReturn;
            return YES;
        }
    }
    
    [aStream setPosition:aPosition];
    return NO;
}

- (void)dealloc
{
    [_keyword release];
    [_expression release];
    [super dealloc];
}

@end
