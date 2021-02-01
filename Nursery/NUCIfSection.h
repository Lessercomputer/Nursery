//
//  NUCIfSection.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCIfGroup, NUCElifGroups, NUCElseGroup, NUCEndifLine;

@interface NUCIfSection : NUCPreprocessingDirective
{
    NUCIfGroup *ifGroup;
    NUCElifGroups *elifGroups;
    NUCElseGroup *elseGroup;
    NUCEndifLine *endifLine;
}

+ (instancetype)ifSectionWithIfGroup:(NUCIfGroup *)anIfGroup elifGroups:(NUCElifGroups *)anElifGroups elseGroup:(NUCElseGroup *)anElseGroup endifLine:(NUCEndifLine *)anEndifLine;

- (instancetype)initWithIfGroup:(NUCIfGroup *)anIfGroup elifGroups:(NUCElifGroups *)anElifGroups elseGroup:(NUCElseGroup *)anElseGroup endifLine:(NUCEndifLine *)anEndifLine;

- (NUCIfGroup *)ifGroup;
- (NUCElifGroups *)elifGroups;
- (NUCElseGroup *)elseGroup;
- (NUCEndifLine *)endifLine;

@end

