//
//  NUCPreprocessingFile.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/11/18.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingFile.h"

@implementation NUCPreprocessingFile

+ (instancetype)preprocessingFileWithGroup:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithGroup:aGroup] autorelease];
}

- (instancetype)initWithGroup:(NUCGroup *)aGroup
{
    if (self = [super initWithType:NUCLexicalElementProcessingFileType])
    {
        group = [aGroup retain];
    }
    
    return self;
}

- (void)dealloc
{
    [group release];
    
    [super dealloc];
}

- (NUCGroup *)group
{
    return group;
}

@end
