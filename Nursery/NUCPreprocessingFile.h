//
//  NUCPreprocessingFile.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/11/18.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCGroup;

@interface NUCPreprocessingFile : NUCPreprocessingDirective
{
    NUCGroup *group;
}

+ (instancetype)preprocessingFileWithGroup:(NUCGroup *)aGroup;

- (instancetype)initWithGroup:(NUCGroup *)aGroup;

- (NUCGroup *)group;

@end
