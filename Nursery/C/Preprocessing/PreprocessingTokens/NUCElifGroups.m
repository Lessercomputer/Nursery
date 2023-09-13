//
//  NUCElifGroups.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCElifGroups.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCElifGroup.h"

#import <Foundation/NSArray.h>

@implementation NUCElifGroups

+ (BOOL)elifGroupsFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCElifGroups **)aToken
{
    NUCElifGroups *anElifGroups = [NUCElifGroups elifGroups];
    NUCElifGroup *anElifGroup = nil;
    
    while ([NUCElifGroup elifGroupFrom:aStream with:aPreprocessor isSkipped:aGroupIsSkipped into:&anElifGroup])
        [anElifGroups add:anElifGroup];

    if (aToken && [anElifGroups count])
        *aToken = anElifGroups;
    
    return [anElifGroups count] ? YES : NO;
}

+ (instancetype)elifGroups
{
    return [[[self alloc] initWithType:NUCLexicalElementElifGroups] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        groups = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [groups release];
    
    [super dealloc];
}

- (void)add:(NUCElifGroup *)anElifGroup
{
    [[self groups] addObject:anElifGroup];
}

- (NSMutableArray *)groups
{
    return groups;
}

- (NSUInteger)count
{
    return [[self groups] count];
}

- (BOOL)isSkipped
{
    return ![self isNonzero];
}

- (BOOL)isNonzero
{
    __block BOOL anIsNonzero = NO;
    
    [[self groups] enumerateObjectsUsingBlock:^(NUCElifGroup * _Nonnull anElifGroup, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([anElifGroup isNonzero])
        {
            anIsNonzero = YES;
            *stop = YES;
        }
    }];
    
    return anIsNonzero;
}

@end
