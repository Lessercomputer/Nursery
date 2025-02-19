//
//  NUCPpTokensWithMacroInvocations.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/14.
//

#import "NUCPpTokensWithMacroInvocations.h"

#import <Foundation/NSArray.h>

@implementation NUCPpTokensWithMacroInvocations

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        overlappedMacroNameIndex = NSUIntegerMax;
    }
    
    return self;
}

- (BOOL)isPpTokensWithMacroInvocations
{
    return YES;
}

- (NSUInteger)overlappedMacroNameIndex
{
    return overlappedMacroNameIndex;
}

- (void)setOverlappedMacroNameIndex:(NSUInteger)anIndex
{
    overlappedMacroNameIndex = anIndex;
}

@end
