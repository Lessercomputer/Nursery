//
//  NUCControlLineDefine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLineDefine.h"

@implementation NUCControlLineDefine

+ (instancetype)defineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier replacementList:aReplacementList newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementDefineType hash:aHash directiveName:aDirectiveName newline:aNewline])
    {
        identifier = [anIdentifier retain];
        replacementList = [aReplacementList retain];
    }
    
    return self;
}

- (void)dealloc
{
    [identifier release];
    [replacementList release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)identifier
{
    return identifier;
}

- (NUCReplacementList *)replacementList
{
    return replacementList;
}

@end
