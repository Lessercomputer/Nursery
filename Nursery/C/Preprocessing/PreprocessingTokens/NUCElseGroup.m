//
//  NUCElseGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCElseGroup.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCNewline.h"
#import "NUCGroup.h"

#import <Foundation/NSString.h>

@implementation NUCElseGroup

+ (BOOL)elseGroupFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCElseGroup **)anElseGroup
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCDecomposedPreprocessingToken *aToken = [aPreprocessingTokenStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCDecomposedPreprocessingToken *aHash = aToken;
        NUCNewline *aNewline = nil;
        NUCDecomposedPreprocessingToken *anElse = [aPreprocessingTokenStream next];
        
        if (anElse && [[anElse content] isEqualToString:NUCPreprocessingDirectiveElse])
        {
            if ([NUCNewline newlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                NUCGroup *aGroup = nil;
                [NUCGroup groupFrom:aPreprocessingTokenStream with:aPreprocessor isSkipped:aGroupIsSkipped into:&aGroup];
                
                if (anElseGroup)
                {
                    *anElseGroup = [NUCElseGroup elseGroupWithHash:aHash directiveName:anElse newline:aNewline group:aGroup];
                }
                
                return YES;
            }
        }
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

+ (instancetype)elseGroupWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)anElse newline:(NUCNewline *)aNewline group:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithHash:aHash directiveName:anElse newline:aNewline group:aGroup] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)anElse newline:(NUCNewline *)aNewline group:(NUCGroup *)aGroup
{
    if (self = [super initWithType:NUCLexicalElementElseType])
    {
        hash = [aHash retain];
        directiveName = [anElse retain];
        newline = [aNewline retain];
        group = [aGroup retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    [directiveName release];
    [newline release];
    [group release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)hash
{
    return hash;
}

- (NUCDecomposedPreprocessingToken *)else
{
    return directiveName;
}

- (NUCNewline *)newline
{
    return newline;
}

- (NUCGroup *)group
{
    return group;
}

- (void)addPpTokensByReplacingMacrosTo:(NSMutableArray *)aMacroReplacedPpTokens with:(NUCPreprocessor *)aPreprocessor;
{
    if (![[self group] isSkipped])
        [[self group] addPpTokensByReplacingMacrosTo:aMacroReplacedPpTokens with:aPreprocessor];
}

@end
