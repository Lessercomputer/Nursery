//
//  NUCParameterDeclaration.m
//  Nursery
//
//  Created by akiha on 2025/02/15.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCParameterDeclaration.h"
#import "NUCDeclarationSpecifiers.h"
#import "NUCDeclarator.h"

@implementation NUCParameterDeclaration

+ (BOOL)parameterDeclarationFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCParameterDeclaration **)aParameterDeclaration
{
    NUCParameterDeclaration *aParameterDeclarationToRetun = [[self new] autorelease];
    NUCDeclarationSpecifiers *aDeclarationSpecifiers = nil;
    
    if ([NUCDeclarationSpecifiers declarationSpecifiersFrom:aStream into:&aDeclarationSpecifiers])
    {
        NUCDeclarator *aDeclarator = nil;
        if ([NUCDeclarator declaratorFrom:aStream into:&aDeclarator])
        {
            if (aParameterDeclaration)
                *aParameterDeclaration = aParameterDeclarationToRetun;
            return YES;
        }
    }
    
    return NO;
}

- (void)dealloc
{
    [_declarationSpecifiers release];
    [_declartor release];
    [super dealloc];
}

@end
