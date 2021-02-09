//
//  NUCTextLine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCTextLine.h"

@implementation NUCTextLine

+ (instancetype)textLineWithPpTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithPpTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithPpTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementTextLineType])
    {
        ppTokens = [aPpTokens retain];
        newline = [aNewline retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    [newline release];
    
    [super dealloc];
}

@end
