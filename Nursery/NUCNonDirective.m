//
//  NUCNonDirective.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCNonDirective.h"

@implementation NUCNonDirective

+ (instancetype)noneDirectiveWithHash:(NUCDecomposedPreprocessingToken *)aHash ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash ppTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithPpTokens:aPpTokens newline:aNewline])
    {
        hash = [aHash retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    
    [super dealloc];
}

@end
