//
//  NUCExternalDeclaration.m
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDeclaration.h"
#import "NUCFunctionDefinition.h"
#import "NUCTranslationOrderMap.h"
#import <Foundation/NSArray.h>

@implementation NUCExternalDeclaration

+ (BOOL)externalDeclarationFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCExternalDeclaration **)anExternalDeclaration
{
    NUCExternalDeclaration *anExternalDeclarationToReturn = [[self new] autorelease];
    
    NUCFunctionDefinition *aFunctionDefinition = nil;
    while ([NUCFunctionDefinition functionDefinitionFrom:aStream into:&aFunctionDefinition])
        [anExternalDeclarationToReturn add:aFunctionDefinition];
        
    if (anExternalDeclaration)
        *anExternalDeclaration = anExternalDeclarationToReturn;
    return YES;
}

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

- (void)add:(NUCExternalDefinition *)anExternalDeclation
{
    [[self externalDeclarations] addObject:anExternalDeclation];
}

- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent depth:(NUUInt64)aDepth
{
    [aMap add:self parent:aParent depth:aDepth];
    [[self externalDeclarations] enumerateObjectsUsingBlock:^(NUCSyntaxElement * _Nonnull aSyntaxElement, NSUInteger idx, BOOL * _Nonnull stop) {
            [aSyntaxElement mapTo:aMap parent:self depth:aDepth + 1];
    }];
}

@end
