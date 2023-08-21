//
//  NUCGroup.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCPreprocessingDirective.h"

@class NUCPreprocessingTokenStream;

@interface NUCGroup : NUCPreprocessingDirective
{
    NSMutableArray *groupParts;
    NSMutableArray *macroReplacedPpTokens;
}

+ (BOOL)groupFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCGroup **)aToken;
+ (instancetype)group;

- (NSMutableArray *)groupParts;
- (NSUInteger)count;

- (void)add:(NUCPreprocessingDirective *)aGroupPart;

- (void)executeMacrosFromAt:(NSUInteger)anIndex count:(NSUInteger)aCount with:(NUCPreprocessor *)aPreprocessor;

@end
