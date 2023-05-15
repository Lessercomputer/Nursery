//
//  NUCElifGroups.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCElifGroup, NUCPreprocessingTokenStream;

@interface NUCElifGroups : NUCPreprocessingDirective
{
    NSMutableArray *groups;
}

+ (BOOL)elifGroupsFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCElifGroups **)aToken;

+ (instancetype)elifGroups;

- (void)add:(NUCElifGroup *)anElifGroup;

- (NSMutableArray *)groups;
- (NSUInteger)count;

@end
