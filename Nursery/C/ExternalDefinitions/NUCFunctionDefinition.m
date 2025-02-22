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
#import "NUCCompoundStatement.h"
#import "NUCPreprocessingTokenToTokenStream.h"

@implementation NUCFunctionDefinition

+ (BOOL)functionDefinitionFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCFunctionDefinition **)aFunctionDefinition
{
    NSUInteger aPosition = [aStream position];
    NUCFunctionDefinition *aFunctionDefinitionToReturn = [[self new] autorelease];
    NUCDeclarationSpecifiers *aDeclarationSpecifiers = nil;
    
    if ([NUCDeclarationSpecifiers declarationSpecifiersFrom:aStream into:&aDeclarationSpecifiers])
    {
        [aFunctionDefinitionToReturn setDeclarationSpecifiers:aDeclarationSpecifiers];
        
        NUCDeclarator *aDeclarator = nil;
        if ([NUCDeclarator declaratorFrom:aStream into:&aDeclarator])
        {
            [aFunctionDefinitionToReturn setDeclarator:aDeclarator];
            
            NUCCompoundStatement *aCompoundStatement = nil;
            if ([NUCCompoundStatement compoundStatementFrom:aStream into:&aCompoundStatement])
            {
                [aFunctionDefinitionToReturn setCompoundStatement:aCompoundStatement];
                
                if (aFunctionDefinition)
                    *aFunctionDefinition = aFunctionDefinitionToReturn;
                return YES;
            }
        }
    }
    
    [aStream setPosition:aPosition];
    return NO;
}

- (void)dealloc
{
    [_declarationSpecifiers release];
    [_declarator release];
    [_compoundStatement release];
    [super dealloc];
}

@end
