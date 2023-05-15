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

#import <Foundation/NSArray.h>

@implementation NUCGroup

+ (BOOL)groupFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCGroup **)aToken
{
    NUCGroup *aGroup = [NUCGroup group];
    NUCPreprocessingDirective *aGroupPart = nil;
    BOOL aTokenScanned = NO;
    
    while ([NUCGroupPart groupPartFrom:aStream into:&aGroupPart])
    {
        aTokenScanned = YES;
        [aGroup add:aGroupPart];
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
