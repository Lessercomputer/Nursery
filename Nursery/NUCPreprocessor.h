//
//  NUCPreprocessor.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSString, NSMutableDictionary, NSMutableArray;
@class NUCTranslator, NUCSourceFile, NUCControlLineDefine, NUCControlLineInclude, NUCIdentifier, NUCPpTokens, NUCConstantExpression;

@interface NUCPreprocessor : NSObject
{
    NUCTranslator *translator;
    NUCSourceFile *sourceFile;
    NSMutableDictionary *macroDefines;
}

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator;

- (NUCTranslator *)translator;
- (NUCSourceFile *)sourceFile;

- (NSMutableDictionary *)macroDefines;
- (NUCControlLineDefine *)macroDefineFor:(NUCIdentifier *)aMacroName;
- (void)setMacroDefine:(NUCControlLineDefine *)aMacroDefine;
- (BOOL)macroIsDefined:(NUCIdentifier *)aMacroName;

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile;

- (void)include:(NUCControlLineInclude *)anInclude;
- (void)define:(NUCControlLineDefine *)aMacroDefine;

- (NUCPpTokens *)ppTokensWithMacroInvocationsByInstantiateMacroInvocationsIn:(NUCPpTokens *)aPpTokens;

- (NUCPpTokens *)executeMacrosInPpTokens:(NUCPpTokens *)aPpTokens;

- (NSInteger)executeConstantExpression:(NUCConstantExpression *)aConstantExpression;

- (NSArray *)executeMacrosInTextLines:(NSArray *)aTextLines;

//- (NUCPpTokens *)instantiateMacroInvocationsIn:(NSArray *)aPpTokens  inRescanningMacros:(BOOL)aRescanningMacros rescanningMacroDefines:(NSMutableArray *)aRescanningMacroDefines;

@end
