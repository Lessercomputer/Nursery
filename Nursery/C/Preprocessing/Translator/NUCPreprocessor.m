//
//  NUCPreprocessor.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//

#import "NUCPreprocessor.h"
#import "NUCDecomposer.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCTranslator.h"
#import "NUCSourceFile.h"
#import "NUCPreprocessingFile.h"
#import "NUCControlLineDefine.h"
#import "NUCControlLineInclude.h"
#import "NUCIdentifier.h"
#import "NUCReplacementList.h"
#import "NUCControlLineDefine.h"
#import "NUCPpTokens.h"
#import "NUCPpTokensWithMacroInvocations.h"
#import "NUCMacroInvocation.h"
#import "NUCConcatenatedPpToken.h"
#import "NUCConstantExpression.h"
#import "NUCTextLine.h"
#import "NUCControlLineDefineFunctionLike.h"
#import "NUCGroupPart.h"
#import "NUCUndef.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>

@implementation NUCPreprocessor

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator
{
    if (self = [super init])
    {
        translator = [aTranslator retain];
        macroDefines = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [translator release];
    translator = nil;
    [macroDefines release];

    
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

- (NSMutableDictionary *)macroDefines
{
    return macroDefines;
}

- (NUCControlLineDefine *)macroDefineFor:(NUCIdentifier *)aMacroName
{
    if (![self parent])
        return [[self macroDefines] objectForKey:aMacroName];
    else
        return [[self parent] macroDefineFor:aMacroName];
}

- (void)removeMacroDefineFor:(NUCIdentifier *)aMacroName
{
    if (![self parent])
        [[self macroDefines] removeObjectForKey:aMacroName];
    else
        [[self parent] removeMacroDefineFor:aMacroName];
}

- (void)setMacroDefine:(NUCControlLineDefine *)aMacroDefine
{
    if (![self parent])
        [[self macroDefines] setObject:aMacroDefine forKey:[aMacroDefine identifier]];
    else
        [[self parent] setMacroDefine:aMacroDefine];
}

- (BOOL)macroIsDefined:(NUCIdentifier *)aMacroName
{
    return [self macroDefineFor:aMacroName] ? YES : NO;
}

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile
{
    sourceFile = aSourceFile;
    
    [[self sourceFile] preprocessFromPhase1ToPhase2];
    [self preprocessPhase4:[self preprocesPhase3]];
    
    sourceFile = nil;
}

- (NSArray *)preprocesPhase3
{
    NUCDecomposer *aDecomposer = [NUCDecomposer new];
    NSArray *aPreprocessingTokens = [aDecomposer decomposePreprocessingFile:[self sourceFile]];
    [aDecomposer release];
    
    return aPreprocessingTokens;
}

- (void)preprocessPhase4:(NSArray *)aPreprocessingTokens
{
    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPreprocessingTokens];
    NUCPreprocessingFile *aPreprocessingFile = nil;
    
    if ([NUCPreprocessingFile preprocessingFileFrom:aStream with:self into:&aPreprocessingFile])
    {
        [[self sourceFile] setPreprocessingFile:aPreprocessingFile];
    }
}

- (void)include:(NUCControlLineInclude *)anInclude
{
    NUCTranslator *aTranslator = [self translator];
    NUCPreprocessor *aSubPreprocessor = [[[[self class] alloc] initWithTranslator:aTranslator] autorelease];
    NUCSourceFile *aSubSouceFile = [aTranslator sourceFileFor:[anInclude filename]];
    [aSubPreprocessor setParent:self];
    [aSubPreprocessor preprocessSourceFile:aSubSouceFile];
    [anInclude setSourceFile:aSubSouceFile];
}

- (void)define:(NUCControlLineDefine *)aMacroDefine
{
    NUCIdentifier *aMacroName = [aMacroDefine identifier];
    NUCControlLineDefine *anExistingMacro = [self macroDefineFor:aMacroName];
    
    if (!anExistingMacro || [anExistingMacro isEqual:aMacroDefine])
        [self setMacroDefine:aMacroDefine];
}

- (void)undef:(NUCUndef *)anUndef
{
    NUCIdentifier *aMacroName = [anUndef identifier];
    [self removeMacroDefineFor:aMacroName];
}

- (void)line:(NUCLine *)aLine
{
    [[self sourceFile] line:aLine];
}

- (void)error:(NUCError *)anError
{
    [[self sourceFile] error:anError];
}

- (void)pragma:(NUCPragma *)aPragma
{
    
}

- (NUCExpressionResult *)executeConstantExpression:(NUCConstantExpression *)aConstantExpression
{
    return [aConstantExpression evaluateWith:self];
}

@end
