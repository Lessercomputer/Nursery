//
//  NUCFunctionDefinition.m
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCFunctionDefinition.h"
#import "NUCDeclarationSpecifiers.h"
#import "NUCDeclarator.h"

@implementation NUCFunctionDefinition

+ (BOOL)functionDefinitionFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCFunctionDefinition **)aFunctionDefinition
{
    NUCFunctionDefinition *aFunctionDefinitionToReturn = [[self new] autorelease];
    NUCDeclarationSpecifiers *aDeclarationSpecifiers = nil;
    
    if ([NUCDeclarationSpecifiers declarationSpecifiersFrom:aStream into:&aDeclarationSpecifiers])
    {
        [aFunctionDefinitionToReturn setDeclarationSpecifiers:aDeclarationSpecifiers];
        
        NUCDeclarator *aDeclarator = nil;
        if ([NUCDeclarator declaratorFrom:aStream into:&aDeclarator])
        {
            [aFunctionDefinitionToReturn setDeclarator:aDeclarator];
        }
        else
            return NO;
    }
    else
        return NO;
    
    if (aFunctionDefinition)
        *aFunctionDefinition = aFunctionDefinitionToReturn;
    return YES;
}

- (void)dealloc
{
    [_declarationSpecifiers release];
    [_declarator release];
    [super dealloc];
}

@end
