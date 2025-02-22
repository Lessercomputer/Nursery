//
//  NUCParameterList.m
//  Nursery
//
//  Created by akiha on 2025/02/15.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCParameterList.h"
#import <Foundation/NSArray.h>
#import "NUCParameterDeclaration.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCTokenProtocol.h"

@implementation NUCParameterList

+ (BOOL)parameterListFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCParameterList **)aParameterList
{
    NUCParameterList *aParameterListToReturn = [[self new] autorelease];
    NUCParameterDeclaration *aParameterDeclaration = nil;

    if ([NUCParameterDeclaration parameterDeclarationFrom:aStream into:&aParameterDeclaration])
        [aParameterListToReturn add:aParameterDeclaration];
    else
        return NO;
    
    
    while (YES)
    {
        NSUInteger aPosition = [aStream position];
        id <NUCToken> aToken = [aStream next];
        
        if ([aToken isComma])
        {
            NUCParameterDeclaration *aParameterDeclaration = nil;
            if ([NUCParameterDeclaration parameterDeclarationFrom:aStream into:&aParameterDeclaration])
                [aParameterListToReturn add:aParameterDeclaration];
            else
            {
                [aStream setPosition:aPosition];
                return NO;
            }
        }
        else
        {
            [aStream setPosition:aPosition];
            break;
        }
    }
    
    if (aParameterList)
        *aParameterList = aParameterListToReturn;
    return YES;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _parameterDeclarations = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_parameterDeclarations release];
    [super dealloc];
}

- (void)add:(NUCParameterDeclaration *)aParameterDeclaration
{
    [[self parameterDeclarations] addObject:aParameterDeclaration];
}

@end
