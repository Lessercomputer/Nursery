//
//  NUCElifGroups.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCElifGroup;

@interface NUCElifGroups : NUCPreprocessingDirective
{
    NSMutableArray *groups;
}

+ (instancetype)elifGroups;

- (void)add:(NUCElifGroup *)anElifGroup;

- (NSMutableArray *)groups;
- (NSUInteger)count;

@end
