//
//  NUCTypeSpecifier.m
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCTypeSpecifier.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCKeyword.h"

@implementation NUCTypeSpecifier

+ (BOOL)typeSpecifierFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCTypeSpecifier **)aTypeSpecifier
{
    NUCTypeSpecifier *aTypeSpecifierToReturn = [[self new] autorelease];
    NSUInteger aPosition = [aStream position];
    id <NUCToken> aToken = [aStream next];
    
    if ([aToken isKeyword])
    {
        NUCKeyword *aKeyword = aToken;
        if ([aKeyword isVoid] || [aKeyword isInt])
        {
            [aTypeSpecifierToReturn setContent:aKeyword];
        }
        else
        {
            [aStream setPosition:aPosition];
            return NO;
        }
    }
    else
    {
        [aStream setPosition:aPosition];
    }
    
    if (aTypeSpecifier)
        *aTypeSpecifier = aTypeSpecifierToReturn;
    return YES;
}

- (void)dealloc
{
    [_content release];
    [super dealloc];
}

@end
