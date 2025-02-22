//
//  NUCDeclarationSpecifiers.m
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCDeclarationSpecifiers.h"
#import "NUCTypeSpecifier.h"
#import <Foundation/NSArray.h>

@implementation NUCDeclarationSpecifiers

+ (BOOL)declarationSpecifiersFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCDeclarationSpecifiers **)aDeclarationSpecifiers
{
    NUCDeclarationSpecifiers *aDeclarationSpecifiersToReturn = [[self new] autorelease];
    
    while (YES)
    {
        NUCTypeSpecifier *aTypeSpecifier = nil;
        if ([NUCTypeSpecifier typeSpecifierFrom:aStream into:&aTypeSpecifier])
        {
            [aDeclarationSpecifiersToReturn add:aTypeSpecifier];
        }
        else
            break;
    }
    
    if ([aDeclarationSpecifiersToReturn count])
    {
        if (aDeclarationSpecifiers)
            *aDeclarationSpecifiers = aDeclarationSpecifiersToReturn;
        return YES;
    }
    else
        return NO;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _specifiers = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_specifiers release];
    
    [super dealloc];
}

- (NSUInteger)count
{
    return [[self specifiers] count];
}

- (void)add:(NUCExternalDefinition *)anExternalDefinition
{
    [[self specifiers] addObject:anExternalDefinition];
}

@end
