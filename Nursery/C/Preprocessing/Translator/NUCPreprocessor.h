//
//  NUCPreprocessor.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//

#import <Foundation/NSObject.h>

@class NSString, NSMutableDictionary, NSMutableArray;
@class NUCTranslator, NUCSourceFile, NUCControlLineDefine, NUCControlLineInclude, NUCUndef,
NUCIdentifier, NUCPpTokens, NUCConstantExpression, NUCPreprocessingToken, NUCLine, NUCError, NUCPragma;

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
- (void)undef:(NUCUndef *)anUndef;
- (void)line:(NUCLine *)aLine;
- (void)error:(NUCError *)anError;
- (void)pragma:(NUCPragma *)aPragma;

- (NSInteger)executeConstantExpression:(NUCConstantExpression *)aConstantExpression;

@end
