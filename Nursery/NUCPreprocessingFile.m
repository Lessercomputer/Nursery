//
//  NUCPreprocessingFile.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/11/18.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingFile.h"
#import "NUCGroup.h"
#import "NUCControlLineDefine.h"
#import "NUCIdentifier.h"

#import <Foundation/NSDictionary.h>

@implementation NUCPreprocessingFile

+ (BOOL)preprocessingFileFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingFile **)aToken
{
    NUCGroup *aGroup = nil;

    if ([NUCGroup groupFrom:aStream into:&aGroup])
    {
        if (aToken)
            *aToken = [self preprocessingFileWithGroup:aGroup];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)preprocessingFileWithGroup:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithGroup:aGroup] autorelease];
}

- (instancetype)initWithGroup:(NUCGroup *)aGroup
{
    if (self = [super initWithType:NUCLexicalElementProcessingFileType])
    {
        group = [aGroup retain];
        macros = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [group release];
    [macros release];
    macros = nil;
    
    [super dealloc];
}

- (NUCGroup *)group
{
    return group;
}

- (NSMutableDictionary *)macros
{
    return macros;
}

- (NUCControlLineDefine *)macroFor:(NUCIdentifier *)aMacroName
{
    return [[self macros] objectForKey:aMacroName];
}

- (void)setMacro:(NUCControlLineDefine *)aMacro
{
    [[self macros] setObject:aMacro forKey:[aMacro identifier]];
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    [[self group] preprocessWith:aPreprocessor];
}

@end
