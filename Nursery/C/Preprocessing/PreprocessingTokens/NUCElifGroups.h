//
//  NUCElifGroups.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCPreprocessingDirective.h"

@class NUCElifGroup, NUCPreprocessingTokenStream;

@interface NUCElifGroups : NUCPreprocessingDirective
{
    NSMutableArray *groups;
}

+ (BOOL)elifGroupsFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCElifGroups **)aToken;

+ (instancetype)elifGroups;

- (void)add:(NUCElifGroup *)anElifGroup;

- (NSMutableArray *)groups;
- (NSUInteger)count;

@end
