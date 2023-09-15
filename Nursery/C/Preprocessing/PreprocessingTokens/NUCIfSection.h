//
//  NUCIfSection.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCPreprocessingDirective.h"

@class NUCIfGroup, NUCElifGroups, NUCElseGroup, NUCEndifLine;
@class NUCPreprocessingTokenStream;

@interface NUCIfSection : NUCPreprocessingDirective
{
    NUCIfGroup *ifGroup;
    NUCElifGroups *elifGroups;
    NUCElseGroup *elseGroup;
    NUCEndifLine *endifLine;
}

+ (BOOL)ifSectionFrom:(NUCPreprocessingTokenStream *)aStream  with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCPreprocessingDirective **)anIfSection;

+ (instancetype)ifSectionWithIfGroup:(NUCIfGroup *)anIfGroup elifGroups:(NUCElifGroups *)anElifGroups elseGroup:(NUCElseGroup *)anElseGroup endifLine:(NUCEndifLine *)anEndifLine;

- (instancetype)initWithIfGroup:(NUCIfGroup *)anIfGroup elifGroups:(NUCElifGroups *)anElifGroups elseGroup:(NUCElseGroup *)anElseGroup endifLine:(NUCEndifLine *)anEndifLine;

- (NUCIfGroup *)ifGroup;
- (NUCElifGroups *)elifGroups;
- (NUCElseGroup *)elseGroup;
- (NUCEndifLine *)endifLine;

@property (nonatomic) BOOL isSkipped;

- (void)addPpTokensByReplacingMacrosTo:(NSMutableArray *)aMacroReplacedPpTokens with:(NUCPreprocessor *)aPreprocessor;

@end

