//
//  NUCPreprocessor.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessor.h"
#import "NUCDecomposer.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCSourceFile.h"
#import "NUCPreprocessingFile.h"
#import "NUCControlLineDefine.h"
#import "NUCIdentifier.h"
#import "NUCReplacementList.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>

@implementation NUCPreprocessor

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator
{
    if (self = [super init])
    {
        translator = [aTranslator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [translator release];
    translator = nil;

    
    [super dealloc];
}

- (NUCTranslator *)translator
{
    return translator;
}

- (NUCSourceFile *)sourceFile
{
    return sourceFile;
}

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile
{
    sourceFile = aSourceFile;
    [aSourceFile preprocessFromPhase1ToPhase2];
    
    NUCDecomposer *aDecomposer = [NUCDecomposer new];
    NSArray *aPreprocessingTokens = [aDecomposer decomposePreprocessingFile:aSourceFile];
    [aDecomposer release];

    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPreprocessingTokens];
    NUCPreprocessingFile *aPreprocessingFile = nil;
    
    if ([NUCPreprocessingFile preprocessingFileFrom:aStream into:&aPreprocessingFile])
    {
        [aSourceFile setPreprocessingFile:aPreprocessingFile];
        [aPreprocessingFile preprocessWith:self];
    }
    
    sourceFile = nil;
}

- (NUCControlLineDefine *)macroFor:(NUCIdentifier *)aMacroName
{
    return [[[self sourceFile] preprocessingFile] macroFor:aMacroName];
}

- (void)setMacro:(NUCControlLineDefine *)aMacro
{
    [[[self sourceFile] preprocessingFile] setMacro:aMacro];
}

- (void)include:(NUCControlLineInclude *)anInclude
{
    
}

- (void)define:(NUCControlLineDefine *)aMacro
{
    NUCIdentifier *aMacroName = [aMacro identifier];
    NUCControlLineDefine *anExistingMacro = [self macroFor:aMacroName];
    
    if (!anExistingMacro || [anExistingMacro isEqual:aMacro])
    {
        [self setMacro:aMacro];
        
        [[aMacro replacementList] enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
            
            if ([aPpToken isIdentifier])
            {
                NUCIdentifier *anIdentifier = (NUCIdentifier *)aPpToken;
                
                if ([anIdentifier isEqual:aMacroName])
                    *aStop = YES;
                else
                {
                    NUCControlLineDefine *aDefinedMacro = [self macroFor:anIdentifier];
                    
                    if (aDefinedMacro)
                        [anIdentifier setReplacementList:[aDefinedMacro replacementList]];
                }
            }
        }];
    }
}

@end
