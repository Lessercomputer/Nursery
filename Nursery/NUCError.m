//
//  NUCError.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2022/03/28.
//  Copyright © 2022 Nursery-Framework. All rights reserved.
//

#import "NUCError.h"

@implementation NUCError

+ (instancetype)errorWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementErrorType hash:aHash directiveName:aDirectiveName newline:aNewline])
    {
        ppTokens = [aPpTokens retain];
    }
    
    return self;
}

- (NUCPpTokens *)ppTokens
{
    return ppTokens;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

@end
