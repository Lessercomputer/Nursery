//
//  NUCReplacementList.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/10.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCReplacementList.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCPpTokens.h"

@implementation NUCReplacementList

+ (BOOL)replacementListFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingDirective **)aToken
{
    NUCPpTokens *aPpTokens = nil;
    
    if ([NUCPpTokens ppTokensFrom:aStream into:&aPpTokens])
    {
        if (aToken)
            *aToken = [NUCReplacementList replacementListWithPpTokens:aPpTokens];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)replacementListWithPpTokens:(NUCPpTokens *)aPpTokens
{
    return [[[self alloc] initWithPpTokens:aPpTokens] autorelease];
}

- (instancetype)initWithPpTokens:(NUCPpTokens *)aPpTokens
{
    if (self = [super initWithType:NUCLexicalElementReplacementListType])
    {
        ppTokens = [aPpTokens retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

@end
