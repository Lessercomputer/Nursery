//
//  NUSourceFile.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import "NUCSourceFile.h"
#import "NULibrary.h"

#import <Foundation/NSString.h>
#import <Foundation/NSURL.h>


@implementation NUCSourceFile

- (instancetype)initWithSourceURL:(NSURL *)aURL
{
    return [self initWithSourceString:[NSString stringWithContentsOfURL:aURL usedEncoding:NULL error:NULL] url:aURL];
}

- (instancetype)initWithSourceString:(NSString *)aString url:(NSURL *)aURL
{
    if (self = [super init])
    {
        url = [aURL copy];
        physicalSourceString = [aString copy];
    }
    
    return self;
}

- (void)dealloc
{
    [url release];
    url = nil;
    [physicalSourceString release];
    physicalSourceString = nil;
    [logicalSourceString release];
    logicalSourceString = nil;
    
    [super dealloc];
}

- (NSString *)physicalSourceString
{
    return physicalSourceString;
}

 - (NSString *)logicalSourceString
{
    return logicalSourceString;
}

- (void)setLogicalSourceString:(NSString *)aString
{
    [logicalSourceString autorelease];
    logicalSourceString = [aString copy];
}

@end
