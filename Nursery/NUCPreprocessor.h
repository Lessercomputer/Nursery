//
//  NUCPreprocessor.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSString, NSMutableDictionary, NUCTranslator, NUCSourceFile, NUCControlLineDefine;

@interface NUCPreprocessor : NSObject
{
    NUCTranslator *translator;
    NSMutableDictionary *macroDictionary;
}

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator;

- (NUCTranslator *)translator;

- (NSMutableDictionary *)macroDictionary;

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile;

- (void)define:(NUCControlLineDefine *)aMacro;

@end
