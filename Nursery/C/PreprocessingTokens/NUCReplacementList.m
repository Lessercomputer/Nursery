//
//  NUCReplacementList.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/10.
//

#import "NUCReplacementList.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCPpTokens.h"

#import <Foundation/NSArray.h>

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
        ppTokens = [aPpTokens retain];
    
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

- (BOOL)isEqual:(id)anOther
{
    if (anOther == self)
        return YES;
    else
        return [[self ppTokens] isEqual:[anOther ppTokens]];
}

- (void)enumerateObjectsUsingBlock:(void (^)(NUCPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop))aBlock;
{
    [[self ppTokens] enumerateObjectsUsingBlock:aBlock];
}

@end
