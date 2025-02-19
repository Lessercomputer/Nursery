//
//  NUCDirectDeclarator.m
//  Nursery
//
//  Created by akiha on 2025/02/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCDirectDeclarator.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCParameterTypeList.h"

@implementation NUCDirectDeclarator

+ (BOOL)directDeclaratorFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCDirectDeclarator **)aDirectDeclarator
{
    NSUInteger aPosition = [aStream position];
    id <NUCToken> aToken = [aStream next];
    NUCDirectDeclarator *aDirectDeclaratorToReturn = nil;
    
    if ([aToken isIdentifier])
    {
        aDirectDeclaratorToReturn = [[self new] autorelease];
        [aDirectDeclaratorToReturn setIdentifier:aToken];
        
        if (aDirectDeclarator)
            *aDirectDeclarator = aDirectDeclaratorToReturn;
        
        return YES;
    }
    else
    {
        NUCDirectDeclarator *anInternalDirectDeclarator = nil;
        if ([self directDeclaratorFrom:aStream into:&anInternalDirectDeclarator])
        {
            aDirectDeclaratorToReturn = [[self new] autorelease];
            id <NUCToken> aToken=  [aStream next];
            
            if ([aToken isOpeningParenthesis])
            {
                [aDirectDeclaratorToReturn setDirectDeclarator:(id <NUCToken>)anInternalDirectDeclarator];
                [aDirectDeclaratorToReturn setOpeningPunctuator:aToken];
                
                NUCParameterTypeList *aParameterTypeList = nil;
                if ([NUCParameterTypeList parameterTypeListFrom:aStream into:&aParameterTypeList])
                {
                    [aDirectDeclaratorToReturn setParameterTypeList:aParameterTypeList];
                    
                    id <NUCToken> aToken = [aStream next];
                    
                    if ([aToken isClosingParenthesis])
                    {
                        [aDirectDeclaratorToReturn setClosingPunctuator:aToken];
                        
                        if (aDirectDeclarator)
                            *aDirectDeclarator = aDirectDeclaratorToReturn;
                        
                        return YES;
                    }
                }
            }
        }
    }
    
    [aStream setPosition:aPosition];
    return NO;
}

- (void)dealloc
{
    [_identifier release];
    [_directDeclarator release];
    [_closingPunctuator release];
    [_openingPunctuator release];
    [_parameterTypeList release];
    [super dealloc];
}

@end
