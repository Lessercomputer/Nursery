//
//  NUCPragma.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2022/03/29.
//

#import "NUCPragma.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPpTokens.h"
#import "NUCNewline.h"
#import "NUCPreprocessor.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

@implementation NUCPragma

+ (BOOL)pragmaFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken
{
    if ([aDirectiveName isIdentifier] && [(NUCIdentifier *)[aDirectiveName content] isEqual:NUCPreprocessingDirectivePragma ])
    {
        NSUInteger aPosition = [aStream position];
        NUCPpTokens *aPpTokens = nil;
        NUCNewline *aNewline = nil;
        
        if ([NUCPpTokens ppTokensFrom:aStream into:&aPpTokens])
        {
            NUCDecomposedPreprocessingToken *aPpToken = [[aPpTokens ppTokens] firstObject];
            
            if ([aPpToken isIdentifier] && [(NUCIdentifier *)[aPpToken content] isEqual:NUCIdentifierSTDC])
            {
                [self verifyStdcPragma:[aPpTokens ppTokens] stdcIndex:NULL pragmaNameIndex:NULL switchIndex:NULL];
            }
            
            [aStream skipWhitespacesWithoutNewline];
            
            if ([NUCNewline newlineFrom:aStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCPragma pragmaWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline];
                
                return YES;
            }
        }
        
        [aStream setPosition:aPosition];
    }
    
    return NO;
}

+ (BOOL)verifyStdcPragma:(NSArray *)aPpTokens stdcIndex:(NSUInteger *)aStdcIndex pragmaNameIndex:(NSUInteger *)aPragmaNameIndex switchIndex:(NSUInteger *)aSwitchIndex
{
    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    NUCDecomposedPreprocessingToken *anIdentifierOrNot = [aStream next];
    
    if ([anIdentifierOrNot isIdentifier] && [(NUCIdentifier *)[anIdentifierOrNot content] isEqual:NUCIdentifierSTDC])
    {
        if (aStdcIndex)
            *aStdcIndex = [aStream position] - 1;
        
        [aStream skipWhitespacesWithoutNewline];
        
        anIdentifierOrNot = [aStream next];
        
        if ([anIdentifierOrNot isIdentifier])
        {
            NSString *aContent = [anIdentifierOrNot content];
            
            if ([aContent isEqual:NUCIdentifierFPCONTRACT] || [aContent isEqual:NUCIdentifierFENVACCESS] || [aContent isEqual:NUCIdentifierCXLIMITEDRANGE])
            {
                if (aPragmaNameIndex)
                    *aPragmaNameIndex = [aStream position] - 1;
                
                [aStream skipWhitespacesWithoutNewline];
                
                anIdentifierOrNot = [aStream next];
                
                if ([anIdentifierOrNot isIdentifier])
                {
                    NSString *aSwitch = [anIdentifierOrNot content];
                    
                    if ([aSwitch isEqual:NUCIdentifierON] || [aSwitch isEqual:NUCIdentifierOFF] || [aSwitch isEqual:NUCIdentifierDEFAULT])
                    {
                        if (aSwitchIndex)
                            *aSwitchIndex = [aStream position] - 1;
                        
                        return YES;
                    }
                }
            }
        }
    }
    
    return NO;
}

+ (instancetype)pragmaWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
   if (self = [super initWithType:NUCLexicalElementErrorType hash:aHash directiveName:aDirectiveName newline:aNewline])
   {
       ppTokens = [aPpTokens retain];
   }
   
   return self;
}

- (NUCPpTokens *)ppTokens
{
   return ppTokens;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    [aPreprocessor pragma:self];
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

@end
