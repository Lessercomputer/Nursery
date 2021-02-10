//
//  NUCControlLine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLine.h"

@implementation NUCControlLine

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:aType])
    {
        hash = [aHash retain];
        directiveName = [aDirectiveName retain];
        newline = [aNewline retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    [directiveName release];
    [newline release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)hash
{
    return hash;
}

- (NUCDecomposedPreprocessingToken *)directiveName
{
    return directiveName;
}

- (NUCNewline *)newline
{
    return newline;
}

@end
