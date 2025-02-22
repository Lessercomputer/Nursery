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
#import "NUCTokenProtocol.h"

@implementation NUCDirectDeclarator

+ (BOOL)directDeclaratorFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCDirectDeclarator **)aDirectDeclarator
{
    return [self directDeclaratorFrom:aStream into:aDirectDeclarator preceding:nil];
}

+ (BOOL)directDeclaratorFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCDirectDeclarator **)aDirectDeclarator preceding:(NUCDirectDeclarator *)aPrecedingDirectDeclarator
{
    NSUInteger aPosition = [aStream position];
    NUCDirectDeclarator *aDirectDeclaratorToReturn = nil;
    
    if (aPrecedingDirectDeclarator)
    {
        if ([aPrecedingDirectDeclarator identifier])
        {
            aDirectDeclaratorToReturn = [[self new] autorelease];
            id <NUCToken> aToken=  [aStream next];
            
            if ([aToken isOpeningParenthesis])
            {
                [aDirectDeclaratorToReturn setDirectDeclarator:(id <NUCToken>)aPrecedingDirectDeclarator];
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
    else
    {
        id <NUCToken> aToken = [aStream next];
        if ([aToken isIdentifier])
        {
            NUCDirectDeclarator *aDirectDeclaratorWithIdentifier = [[self new] autorelease];
            [aDirectDeclaratorWithIdentifier setIdentifier:aToken];
            
            if (![self directDeclaratorFrom:aStream into:&aDirectDeclaratorToReturn preceding:aDirectDeclaratorWithIdentifier])
                aDirectDeclaratorToReturn = aDirectDeclaratorWithIdentifier;
            
            if (aDirectDeclarator)
                *aDirectDeclarator = aDirectDeclaratorToReturn;
            return YES;
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
