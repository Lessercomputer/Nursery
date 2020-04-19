//
//  NUCPreprocesser.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSString, NUCTranslationEnvironment, NUCSourceFile;

@interface NUCPreprocesser : NSObject
{
    NUCTranslationEnvironment *translationEnvironment;
}

- (instancetype)initWithTranslationEnvironment:(NUCTranslationEnvironment *)aTranslationEnvironment;

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile;

@end
