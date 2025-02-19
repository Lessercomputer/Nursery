//
//  NUCDeclarator.m
//  Nursery
//
//  Created by akiha on 2025/02/05.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCDeclarator.h"
#import "NUCDirectDeclarator.h"

@implementation NUCDeclarator

+ (BOOL)declaratorFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCDeclarator **)aDeclarator
{
    NUCDeclarator *aDeclaratorToReturn = [[self new] autorelease];
    
    NUCDirectDeclarator *aDirectDeclarator = nil;
    if ([NUCDirectDeclarator directDeclaratorFrom:aStream into:&aDirectDeclarator])
    {
        if (aDeclarator)
            *aDeclarator = aDeclaratorToReturn;
        return YES;
    }
    
    return NO;
}

- (void)dealloc
{
    [_pointer release];
    [_directDeclarator release];
    
    [super dealloc];
}

@end
