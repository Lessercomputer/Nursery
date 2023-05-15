//
//  NUCGroup.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPreprocessingTokenStream;

@interface NUCGroup : NUCPreprocessingDirective
{
    NSMutableArray *groupParts;
}

+ (BOOL)groupFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCGroup **)aToken;
+ (instancetype)group;

- (NSMutableArray *)groupParts;
- (NSUInteger)count;

- (void)add:(NUCPreprocessingDirective *)aGroupPart;

@end
