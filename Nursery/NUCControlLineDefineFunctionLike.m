//
//  NUCControlLineDefineFunctionLike.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLineDefineFunctionLike.h"

@implementation NUCControlLineDefineFunctionLike

+ (instancetype)defineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen identifierList:(NUCIdentifierList *)anIdentifierList ellipsis:(NUCDecomposedPreprocessingToken *)anEllipsis rparen:(NUCDecomposedPreprocessingToken *)anRparen replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier lparen:anLparen identifierList:anIdentifierList ellipsis:anEllipsis rparen:anRparen replacementList:aReplacementList newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen identifierList:(NUCIdentifierList *)anIdentifierList ellipsis:(NUCDecomposedPreprocessingToken *)anEllipsis rparen:(NUCDecomposedPreprocessingToken *)anRparen replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline
{
    if (self = [super initWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier replacementList:aReplacementList newline:aNewline])
    {
        lparen = [anLparen retain];
        identifierList = [anIdentifierList retain];
        ellipsis = [anEllipsis retain];
        rparen = [anRparen retain];
    }
    
    return self;
}

- (void)dealloc
{
    [lparen release];
    [identifierList release];
    [ellipsis release];
    [rparen release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)lparen
{
    return lparen;
}

- (NUCIdentifierList *)identifierList
{
    return identifierList;
}

- (NUCDecomposedPreprocessingToken *)ellipsis
{
    return ellipsis;
}

- (NUCDecomposedPreprocessingToken *)rparen
{
    return rparen;
}

@end
