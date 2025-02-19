//
//  NUCTranslationUnit.m
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCTranslationUnit.h"
#import "NUCExternalDeclaration.h"
#import <Foundation/NSArray.h>

@implementation NUCTranslationUnit

- (instancetype)init
{
    if (self = [super init])
    {
        _externalDeclarations = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_externalDeclarations release];
    
    [super dealloc];
}

+ (BOOL)translationUnitFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCTranslationUnit **)aTranslationUnit
{
    NUCTranslationUnit *aTranslationUnitToReturn = [[self new] autorelease];
    NUCExternalDeclaration *anExternalDeclaration = nil;
    
    if ([NUCExternalDeclaration externalDeclarationFrom:aStream into:&anExternalDeclaration])
    {
        [aTranslationUnitToReturn add:anExternalDeclaration];
    }
    
    if (aTranslationUnit)
        *aTranslationUnit = aTranslationUnitToReturn;
    return YES;
}

- (void)add:(NUCExternalDeclaration *)anExternalDeclaration
{
    [[self externalDeclarations] addObject:anExternalDeclaration];
}

@end
