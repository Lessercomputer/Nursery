//
//  NUCElifGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCElifGroup.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConstantExpression.h"
#import "NUCNewline.h"
#import "NUCGroup.h"
#import "NUCPreprocessor.h"

#import <Foundation/NSString.h>

@implementation NUCElifGroup

+ (BOOL)elifGroupFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCElifGroup **)anElifGroup
{
    NSUInteger aPosition = [aStream position];
    [aStream skipWhitespaces];
    NUCDecomposedPreprocessingToken *aToken = [aStream next];
    
    if (aToken && [aToken isHash])
    {
        [aStream skipWhitespacesWithoutNewline];
        NUCDecomposedPreprocessingToken *anElif = [aStream next];
        NSInteger anExpressionValue = 0;
        
        if ([[anElif content] isEqualToString:NUCPreprocessingDirectiveElif])
        {
            NUCLexicalElement *aConstantExpression = nil;
            NUCNewline *aNewline = nil;

            if (!aGroupIsSkipped)
            {
                [aStream skipWhitespacesWithoutNewline];

                if ([NUCConstantExpression constantExpressionFrom:aStream into:&aConstantExpression])
                    anExpressionValue = [aPreprocessor executeConstantExpression:(NUCConstantExpression *)aConstantExpression];
                
                [aStream skipWhitespacesWithoutNewline];
            }
            else
                [self readPpTokensUntilNewlineFrom:aStream into:&aConstantExpression];

            if (aConstantExpression && [NUCNewline newlineFrom:aStream into:&aNewline])
            {
                NUCGroup *aGroup = nil;
                [NUCGroup groupFrom:aStream with:aPreprocessor isSkipped:aGroupIsSkipped into:&aGroup];
                
                if (anElifGroup)
                {
                    *anElifGroup = [NUCElifGroup elifGroupWithType:NUCLexicalElementElifGroup hash:aToken directiveName:anElif expressionOrIdentifier:aConstantExpression newline:aNewline group:aGroup];
                    if (!aGroupIsSkipped && anExpressionValue)
                    {
                        [*anElifGroup setIsSkipped:NO];
                        [*anElifGroup setExpressionValue:anExpressionValue];
                    }
                    else
                        [*anElifGroup setIsSkipped:YES];
                }
                
                return YES;
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
