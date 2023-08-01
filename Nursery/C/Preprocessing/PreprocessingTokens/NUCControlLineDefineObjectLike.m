//
//  NUCControlLineDefineObjectLike.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLineDefineObjectLike.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCReplacementList.h"
#import "NUCNewline.h"

@implementation NUCControlLineDefineObjectLike

+ (BOOL)controlLineDefineObjectLikeFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCIdentifier *)anIdentifier into:(NUCPreprocessingDirective **)aToken
{
    NUCReplacementList *aReplacementList = nil;
    NUCNewline *aNewline = nil;

    [aStream skipWhitespacesWithoutNewline];
    [NUCReplacementList replacementListFrom:aStream into:&aReplacementList];
    [aStream skipWhitespacesWithoutNewline];
    
    if ([NUCNewline newlineFrom:aStream into:&aNewline])
    {
        if (aNewline)
        {
            if (aToken)
                *aToken = [NUCControlLineDefineObjectLike defineWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier replacementList:aReplacementList newline:aNewline];
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isObjectLike
{
    return YES;
}

@end
