//
//  NUCGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCGroup.h"
#import "NUCPreprocessingFile.h"
#import "NUCGroupPart.h"
#import "NUCPreprocessor.h"
#import "NUCControlLine.h"
#import "NUCMacroInvocation.h"
#import "NUCPpTokens.h"
#import "NUCIfSection.h"
#import "NUCError.h"
#import "NUCPragmaOperator.h"

#import <Foundation/NSArray.h>

@implementation NUCGroup

@synthesize macroReplacedPpTokens;

+ (BOOL)groupFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCGroup **)aToken
{
    NUCGroup *aGroup = [NUCGroup group];
    [aGroup setIsSkipped:aGroupIsSkipped];
    NUCPreprocessingDirective *aGroupPart = nil;
    BOOL aTokenScanned = NO;
    NSInteger aLineIndex = 0;
    NSInteger aLineCount = 0;
    NSMutableArray *aMacroReplacesPpTokens = [NSMutableArray array];
    
    while ([NUCGroupPart groupPartFrom:aStream with:aPreprocessor isSkipped:aGroupIsSkipped into:&aGroupPart])
    {
        aTokenScanned = YES;
        [aGroup add:aGroupPart];
        
        if (!aGroupIsSkipped)
        {
            if ([aGroupPart isTextLine])
            {
                if (!aLineCount)
                    aLineIndex = [aGroup count] - 1;
                aLineCount++;
            }
            else
            {
                if (aLineCount)
                {
                    [aGroup addPpTokensByReplacingMacrosInTextLinesFrom:aLineIndex count:aLineCount to:aMacroReplacesPpTokens with:aPreprocessor];
                    aLineCount = 0;
                }
                
                if ([aGroupPart isControlLine])
                {
                    NUCControlLine *aControlLine = (NUCControlLine *)[(NUCGroupPart *)aGroupPart content];
                    [aControlLine preprocessWith:aPreprocessor];

                    if ([aControlLine isInclude])
                        [(NUCControlLineInclude *)aControlLine addPpTokensByReplacingMacrosTo:aMacroReplacesPpTokens with:aPreprocessor];
                }
                else if ([aGroupPart isIfSection])
                {
                    [(NUCIfSection *)[(NUCGroupPart *)aGroupPart content] addPpTokensByReplacingMacrosTo:aMacroReplacesPpTokens with:aPreprocessor];
                }
            }
        }
    }
    
    if (aLineCount)
        [aGroup addPpTokensByReplacingMacrosInTextLinesFrom:aLineIndex count:aLineCount to:aMacroReplacesPpTokens with:aPreprocessor];
    
    [aGroup setMacroReplacedPpTokens:aMacroReplacesPpTokens];

    if (aToken)
        *aToken = aGroup;
    
    return aTokenScanned;
}

+ (instancetype)group
{
    return [[[self alloc] initWithType:NUCLexicalElementGroupType] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        groupParts = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [groupParts release];
    [macroReplacedPpTokens release];
    
    [super dealloc];
}

- (NSMutableArray *)groupParts
{
    return groupParts;
}

- (NSUInteger)count
{
    return [[self groupParts] count];
}

- (void)add:(NUCPreprocessingDirective *)aGroupPart
{
    [[self groupParts] addObject:aGroupPart];
}

- (NSMutableArray *)replaceMacrosWith:(NUCPreprocessor *)aPreprocessor
{
    NSMutableArray *aMacroExpandedPpTokens = [NSMutableArray array];
    
    [self addPpTokensByReplacingMacrosTo:aMacroExpandedPpTokens with:aPreprocessor];
    
    return aMacroExpandedPpTokens;
}

- (void)addPpTokensByReplacingMacrosTo:(NSMutableArray *)aMacroReplacedPpTokens with:(NUCPreprocessor *)aPreprocessor
{
    __block NSUInteger aTextLineIndex;
    __block NSUInteger aTextLineCount = 0;
    
    [[self groupParts] enumerateObjectsUsingBlock:^(NUCGroupPart * _Nonnull aGroupPart, NSUInteger anIndex, BOOL * _Nonnull stop) {
        if ([aGroupPart isTextLine])
        {
            if (!aTextLineCount)
                aTextLineIndex = anIndex;
        
            aTextLineCount++;
        }
        else
        {
            if (aTextLineCount)
            {
                [self addPpTokensByReplacingMacrosInTextLinesFrom:aTextLineIndex count:aTextLineCount to:aMacroReplacedPpTokens with:aPreprocessor];
                aTextLineCount = 0;
            }
            
            if ([aGroupPart isIfSection])
                [(NUCIfSection *)[aGroupPart content] addPpTokensByReplacingMacrosTo:aMacroReplacedPpTokens with:aPreprocessor];
        }
    }];
    
    if (aTextLineCount)
        [self addPpTokensByReplacingMacrosInTextLinesFrom:aTextLineIndex count:aTextLineCount to:aMacroReplacedPpTokens with:aPreprocessor];
}


- (void)addPpTokensByReplacingMacrosInTextLinesFrom:(NSUInteger)anIndex count:(NSUInteger)aCount to:(NSMutableArray *)aPpTokens with:(NUCPreprocessor *)aPreprocessor
{
    NSArray *aTextLines = [[self groupParts] subarrayWithRange:NSMakeRange(anIndex, aCount)];
    NUCPpTokens *aPpTokensWithMacroInvocations = [NUCPpTokens ppTokensWithMacroInvocationsFromTextLines:aTextLines with:aPreprocessor];
    NSMutableArray *aMacroReplacedPpTokens = [aPpTokensWithMacroInvocations replaceMacrosWith:aPreprocessor];
    NSMutableArray *aPragmaOperatorExecutedPpTokens = [NUCPragmaOperator executePragmaOperatorsIn:aMacroReplacedPpTokens preprocessor:aPreprocessor];
    [aPpTokens addObjectsFromArray:aPragmaOperatorExecutedPpTokens];
}

- (void)addPreprocessedStringTo:(NSMutableString *)aString with:(NUCPreprocessor *)aPreprocessor
{
    [[self macroReplacedPpTokens] enumerateObjectsUsingBlock:^(NUCPreprocessingToken * _Nonnull aPpToken, NSUInteger idx, BOOL * _Nonnull stop) {
        [aPpToken addPreprocessedStringTo:aString with:aPreprocessor];
    }];
}

@end
