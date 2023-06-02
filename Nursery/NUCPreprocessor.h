//
//  NUCPreprocessor.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSString, NSMutableDictionary, NUCTranslator, NUCSourceFile, NUCControlLineDefine, NUCControlLineInclude, NUCIdentifier;

@interface NUCPreprocessor : NSObject
{
    NUCTranslator *translator;
    NUCSourceFile *sourceFile;
}

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator;

- (NUCTranslator *)translator;
- (NUCSourceFile *)sourceFile;

- (NUCControlLineDefine *)macroFor:(NUCIdentifier *)aMacroName;

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile;

- (void)include:(NUCControlLineInclude *)anInclude;
- (void)define:(NUCControlLineDefine *)aMacro;

@end
