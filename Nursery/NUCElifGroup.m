//
//  NUCElifGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCElifGroup.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConstantExpression.h"
#import "NUCNewline.h"
#import "NUCGroup.h"

#import <Foundation/NSString.h>

@implementation NUCElifGroup

+ (BOOL)elifGroupFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCElifGroup **)anElifGroup
{
    NSUInteger aPosition = [aStream position];
    [aStream skipWhitespaces];
    NUCDecomposedPreprocessingToken *aToken = [aStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCLexicalElement *aConstantExpression = nil;
        
        if ([aStream skipWhitespacesWithoutNewline])
        {
            NUCDecomposedPreprocessingToken *anElif = [aStream next];
            if ([[anElif content] isEqualToString:NUCPreprocessingDirectiveElif])
            {
                if ([NUCConstantExpression constantExpressionFrom:aStream into:&aConstantExpression])
                {
                    NUCNewline *aNewline = nil;
                    [aStream skipWhitespacesWithoutNewline];
                    
                    if ([NUCNewline newlineFrom:aStream into:&aNewline])
                    {
                        NUCGroup *aGroup = nil;
                        [NUCGroup groupFrom:aStream into:&aGroup];
                        
                        if (anElifGroup)
                            *anElifGroup = [NUCElifGroup elifGroupWithType:NUCLexicalElementElifGroup hash:aToken directiveName:anElif expressionOrIdentifier:aConstantExpression newline:aNewline group:aGroup];
                    }
                    
                    return YES;
                }
            }
        }
    }

    [aStream setPosition:aPosition];
    
    return NO;
}

+ (instancetype)elifGroupWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)anElif expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithType:aType hash:aHash directiveName:anElif expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup] autorelease];
}

@end
