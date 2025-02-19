//
//  NUCStatement.m
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCStatement.h"
#import "NUCJumpStatement.h"

@implementation NUCStatement

+ (BOOL)statementFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCStatement **)aStatement
{
    NUCStatement *aStatementToReturn = [[self new] autorelease];
    
    id anAnyStatement = nil;
    if ([NUCJumpStatement jumpStatementFrom:aStream into:(NUCJumpStatement **)&anAnyStatement])
    {
        [aStatementToReturn setStatement:anAnyStatement];
    }
    else
        return NO;
    
    if (aStatement)
        *aStatement = aStatementToReturn;
    return YES;
}

- (void)dealloc
{
    [_statement release];
    [super dealloc];
}

@end
