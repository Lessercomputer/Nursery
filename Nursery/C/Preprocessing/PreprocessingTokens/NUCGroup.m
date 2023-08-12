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
                    [self executeMacrosAt:aCurrentTextLinesBeginningIndex count:aCurrentTextLineCount inGroup:aGroup with:aPreprocessor];
                    
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
        [self executeMacrosAt:aCurrentTextLinesBeginningIndex count:aCurrentTextLineCount inGroup:aGroup with:aPreprocessor];
    
    if (aToken)
        *aToken = aGroup;
    
    return aTokenScanned;
}

+ (void)executeMacrosAt:(NSUInteger)aTextLineBeginningIndex count:(NSUInteger)aTextLineCount inGroup:(NUCGroup *)aGroup with:(NUCPreprocessor *)aPreprocessor
{
    NSArray *aCurrentTextLines = [[aGroup groupParts] subarrayWithRange:NSMakeRange(aTextLineBeginningIndex, aTextLineCount)];
    
    NUCPpTokens *aPpTokensWithMacroInvocations = [NUCPpTokens ppTokensWithMacroInvocationsFromTextLines:aCurrentTextLines with:aPreprocessor];
    
    NSMutableArray *aMacroReplacedPpTokens = [aPpTokensWithMacroInvocations replaceMacrosWith:aPreprocessor];
    NSLog(@"%@", aMacroReplacedPpTokens);
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

@end
