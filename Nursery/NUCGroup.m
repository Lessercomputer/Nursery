//
//  NUCGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCGroup.h"
#import "NUCPreprocessingFile.h"
#import "NUCGroupPart.h"
#import "NUCPreprocessor.h"

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
                    NSArray *aCurrentTextLines = [[aGroup groupParts] subarrayWithRange:NSMakeRange(aCurrentTextLinesBeginningIndex, aCurrentTextLineCount)];
                    
                    NUCPreprocessingToken *aPpTokensWithMacroInvocations = [aPreprocessor instantiateMacroInvocationsInTextLines:aCurrentTextLines];
                    
                    [aPreprocessor executeMacrosInPpTokens:aPpTokensWithMacroInvocations];
                    
                    aCurrentTextLinesBeginningIndex = NSUIntegerMax;
                    aCurrentTextLineCount = 0;
                }
            }
        }
    }
    
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
