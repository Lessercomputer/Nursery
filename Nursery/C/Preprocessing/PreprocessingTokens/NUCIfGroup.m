//
//  NUCIfGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCIfGroup.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCNewline.h"
#import "NUCGroup.h"
#import "NUCConstantExpression.h"
#import "NUCPreprocessor.h"
#import "NUCPpTokens.h"
#import "NUCMacroInvocation.h"

#import <Foundation/NSString.h>

@implementation NUCIfGroup

+ (BOOL)ifGroupFrom:(NUCPreprocessingTokenStream *)aStream  with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCIfGroup **)anIfGroup
{
    NSUInteger aPosition = [aStream position];
    [aStream skipWhitespaces];
    NUCDecomposedPreprocessingToken *aToken = [aStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCDecomposedPreprocessingToken *aHash = aToken;
        [aStream skipWhitespacesWithoutNewline];
        aToken = [aStream next];
        
        if (aToken)
        {
            NSString *anIfGroupTypeString = [aToken content];
            NUCLexicalElementType anIfGroupType = [self lexicalElementTypeForDirectiveName:anIfGroupTypeString];
            NUCDecomposedPreprocessingToken *aTypeName = aToken;
            NUCLexicalElement *anExpressionOrIdentifier = nil;
            NUCNewline *aNewline = nil;
            NSInteger anExpressionValue = 0;

            if (!aGroupIsSkipped)
            {
                if (anIfGroupType == NUCLexicalElementIfType)
                {
                    [aStream skipWhitespacesWithoutNewline];
                    
                    NUCPpTokens *aPpTokens = nil;
                    [self readPpTokensUntilNewlineFrom:aStream into:&aPpTokens];
                    
                    NUCPpTokens *aPpTokensWithMacroInvocations = [NUCPpTokens ppTokensWithMacroInvocationsFromPpTokens:aPpTokens with:aPreprocessor];
                    
                    NSMutableArray *aMacroReplacedPpTokens =  [aPpTokensWithMacroInvocations replaceMacrosWith:aPreprocessor];
                    
                    NUCPreprocessingTokenStream *aMacroReplacedPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aMacroReplacedPpTokens];
                    
                    [NUCConstantExpression constantExpressionFrom:aMacroReplacedPpTokenStream into:&anExpressionOrIdentifier];
                    
                    anExpressionValue = [aPreprocessor executeConstantExpression:(NUCConstantExpression *)anExpressionOrIdentifier];
                }
                else if (anIfGroupType == NUCLexicalElementIfdefType
                    || anIfGroupType == NUCLexicalElementIfndefType)
                {
                    [aStream skipWhitespaces];
                    anExpressionOrIdentifier = [aStream next];
                    BOOL aMacroIsDeffined = [aPreprocessor macroIsDefined:(NUCIdentifier *)anExpressionOrIdentifier];
                    
                    if (anIfGroupType == NUCLexicalElementIfdefType)
                        anExpressionValue = aMacroIsDeffined ? 1 : 0;
                    else
                        anExpressionValue = aMacroIsDeffined ? 0 : 1;
                }
            }
            else
                [self readPpTokensUntilNewlineFrom:aStream into:&anExpressionOrIdentifier];
            
            if (aHash && anExpressionOrIdentifier && [NUCNewline newlineFrom:aStream into:&aNewline])
            {
                NUCGroup *aGroup = nil;
                [NUCGroup groupFrom:aStream with:aPreprocessor isSkipped:aGroupIsSkipped ? YES : anExpressionValue ? NO : YES into:&aGroup];
                
                if (anIfGroup)
                    *anIfGroup = [NUCIfGroup ifGroupWithType:anIfGroupType hash:aHash
                                                    directiveName:aTypeName expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup];
                
                return YES;
            }
        }
    }

    [aStream setPosition:aPosition];
    
    return NO;
}

+ (NUCLexicalElementType)lexicalElementTypeForDirectiveName:(NSString *)aName
{
    NUCLexicalElementType anIfGroupType = NUCLexicalElementNone;
    
    if ([aName isEqualToString:NUCPreprocessingDirectiveIf])
        anIfGroupType = NUCLexicalElementIfType;
    else if ([aName isEqualToString:NUCPreprocessingDirectiveIfdef])
        anIfGroupType = NUCLexicalElementIfdefType;
    else if ([aName isEqualToString:NUCPreprocessingDirectiveIfndef])
        anIfGroupType = NUCLexicalElementIfndefType;
    
    return anIfGroupType;
}

+ (instancetype)ifGroupWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aName expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithType:aType hash:aHash directiveName:aName expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aName expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    if (self = [super initWithType:aType])
    {
        hash = [aHash retain];
        directiveName = [aName retain];
        expressionOrIdentifier = [anExpressionOrIdentifier retain];
        newline = [aNewline retain];
        group = [aGroup retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    [directiveName release];
    [expressionOrIdentifier release];
    [newline release];
    [group release];
    
    [super dealloc];
}

- (BOOL)isIf
{
    return [self type] == NUCLexicalElementIfType;
}

- (BOOL)isElif
{
    return [self type] == NUCLexicalElementElifGroup;
}

- (BOOL)isIfdef
{
    return [self type] == NUCLexicalElementIfdefType;
}

- (BOOL)isIfndef
{
    return [self type] == NUCLexicalElementIfndefType;
}

- (NUCDecomposedPreprocessingToken *)hash
{
    return hash;
}

- (NUCLexicalElement *)expression
{
    return [self isIf] || [self isElif] ? expressionOrIdentifier : nil;
}

- (NUCLexicalElement *)identifier
{
    return ![self isIf] ? expressionOrIdentifier : nil;
}

- (NUCPreprocessingDirective *)newline
{
    return newline;
}

- (NUCGroup *)group
{
    return group;
}

@end
