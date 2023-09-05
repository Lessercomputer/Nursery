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

#import <Foundation/NSArray.h>

@implementation NUCGroup

+ (BOOL)groupFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCGroup **)aToken
{
    NUCGroup *aGroup = [NUCGroup group];
    NUCPreprocessingDirective *aGroupPart = nil;
    BOOL aTokenScanned = NO;
    NSUInteger aCurrentTextLinesBeginningIndex = NSUIntegerMax;
    NSUInteger aCurrentTextLineCount = 0;
    
    while ([NUCGroupPart groupPartFrom:aStream with:aPreprocessor isSkipped:aGroupIsSkipped into:&aGroupPart])
    {
        aTokenScanned = YES;
        [aGroup add:aGroupPart];
        
        if (!aGroupIsSkipped)
        {
            if ([aGroupPart isTextLine])
            {
                if (aCurrentTextLinesBeginningIndex == NSUIntegerMax)
                    aCurrentTextLinesBeginningIndex = [aGroup count] - 1;
                
                aCurrentTextLineCount++;
            }
            else
            {
                if (aCurrentTextLinesBeginningIndex != NSUIntegerMax)
                {
                    [aGroup executeMacrosFromAt:aCurrentTextLinesBeginningIndex count:aCurrentTextLineCount with:aPreprocessor];
                    
                    aCurrentTextLinesBeginningIndex = NSUIntegerMax;
                    aCurrentTextLineCount = 0;
                }
                
                if ([aGroupPart isControlLine])
                {
                    NUCControlLine *aControlLine = (NUCControlLine *)[(NUCGroupPart *)aGroupPart content];
                    [aControlLine preprocessWith:aPreprocessor];
                }
            }
        }
    }
    
    if (aCurrentTextLineCount)
        [aGroup executeMacrosFromAt:aCurrentTextLinesBeginningIndex count:aCurrentTextLineCount with:aPreprocessor];
    
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
        macroReplacedPpTokens = [NSMutableArray new];
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

- (NSMutableArray *)macroReplacedPpTokens
{
    return macroReplacedPpTokens;
}

- (void)executeMacrosFromAt:(NSUInteger)anIndex count:(NSUInteger)aCount with:(NUCPreprocessor *)aPreprocessor
{
    NSArray *aCurrentTextLines = [[self groupParts] subarrayWithRange:NSMakeRange(anIndex, aCount)];
    NUCPpTokens *aPpTokensWithMacroInvocations = [NUCPpTokens ppTokensWithMacroInvocationsFromTextLines:aCurrentTextLines with:aPreprocessor];
    NSMutableArray *aMacroReplacedPpTokens = [aPpTokensWithMacroInvocations replaceMacrosWith:aPreprocessor];
    [[self macroReplacedPpTokens] addObjectsFromArray:aMacroReplacedPpTokens];
    
    NSLog(@"%@", aMacroReplacedPpTokens);
    
}

- (void)addPreprocessedStringTo:(NSMutableString *)aString
{
    [[self macroReplacedPpTokens] enumerateObjectsUsingBlock:^(NUCPreprocessingToken * _Nonnull aPpToken, NSUInteger idx, BOOL * _Nonnull stop) {
        [aPpToken addPreprocessedStringTo:aString];
    }];
}

@end
