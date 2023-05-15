//
//  NUCPreprocessor.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSString, NUCTranslator, NUCSourceFile;

@interface NUCPreprocessor : NSObject
{
    NUCTranslator *translator;
}

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator;

- (NUCTranslator *)translator;

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile;

@end
