//
//  NUCEndifLine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCEndifLine.h"

@implementation NUCEndifLine

+ (instancetype)endifLineWithHash:(NUCPreprocessingToken *)aHash endif:(NUCPreprocessingToken *)anEndif newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash endif:anEndif newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCPreprocessingToken *)aHash endif:(NUCPreprocessingToken *)anEndif newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementEndifLineType])
    {
        hash = [aHash retain];
        endif = [anEndif retain];
        newline = [aNewline retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    [endif release];
    [newline release];
    
    [super dealloc];
}

- (NUCPreprocessingToken *)hash
{
    return hash;
}

- (NUCPreprocessingToken *)endif
{
    return endif;
}

- (NUCNewline *)newline
{
    return newline;
}

@end
