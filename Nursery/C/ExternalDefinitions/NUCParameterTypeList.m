//
//  NUCParameterTypeList.m
//  Nursery
//
//  Created by akiha on 2025/02/15.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCParameterTypeList.h"
#import "NUCParameterList.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCTokenProtocol.h"

@implementation NUCParameterTypeList

+ (BOOL)parameterTypeListFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCParameterTypeList **)aParameterTypeList
{
    NUCParameterTypeList *aParameterTypeListToReturn = [[self new] autorelease];
    NUCParameterList *aParameterList = nil;
    
    if ([NUCParameterList parameterListFrom:aStream into:&aParameterList])
    {
        [aParameterTypeListToReturn setParameterList:aParameterList];
        
        NSUInteger aPosition = [aStream position];
        id <NUCToken> aToken = [aStream next];
        
        if ([aToken isComma])
        {
            [aParameterTypeListToReturn setComma:aToken];
            
            id <NUCToken> aToken = [aStream next];
            
            if ([aToken isEllipsis])
            {
                [aParameterTypeListToReturn setEllipsis:aToken];
            }
            else
            {
                [aStream setPosition:aPosition];
                return NO;
            }
        }
        else
            [aStream setPosition:aPosition];
        
        if (aParameterTypeList)
            *aParameterTypeList = aParameterTypeListToReturn;
        return YES;
    }
    
    return NO;
}

- (void)dealloc
{
    [_comma release];
    [_ellipsis release];
    [_parameterList release];
    [super dealloc];
}

@end
