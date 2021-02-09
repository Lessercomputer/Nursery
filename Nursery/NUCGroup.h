//
//  NUCGroup.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"


@interface NUCGroup : NUCPreprocessingDirective
{
    NSMutableArray *groupParts;
}

+ (instancetype)group;

- (NSMutableArray *)groupParts;
- (NSUInteger)count;

- (void)add:(NUCPreprocessingDirective *)aGroupPart;

@end
