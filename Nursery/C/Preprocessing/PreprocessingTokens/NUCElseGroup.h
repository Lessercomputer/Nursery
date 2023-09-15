//
//  NUCElseGroup.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCPreprocessingDirective.h"

@class NUCDecomposedPreprocessingToken, NUCNewline, NUCGroup, NUCPreprocessingTokenStream;

@interface NUCElseGroup : NUCPreprocessingDirective
{
    NUCDecomposedPreprocessingToken *hash;
    NUCDecomposedPreprocessingToken *directiveName;
    NUCNewline *newline;
    NUCGroup *group;
}

+ (BOOL)elseGroupFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCElseGroup **)anElseGroup;

+ (instancetype)elseGroupWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)anElse newline:(NUCNewline *)aNewline group:(NUCGroup *)aGroup;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)anElse newline:(NUCNewline *)aNewline group:(NUCGroup *)aGroup;

- (NUCDecomposedPreprocessingToken *)hash;
- (NUCDecomposedPreprocessingToken *)else;
- (NUCNewline *)newline;
- (NUCGroup *)group;

@property (nonatomic) BOOL isSkipped;

- (void)addPpTokensByReplacingMacrosTo:(NSMutableArray *)aMacroReplacedPpTokens with:(NUCPreprocessor *)aPreprocessor;

@end
