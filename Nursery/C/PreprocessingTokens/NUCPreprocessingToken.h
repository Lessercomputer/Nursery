//
//  NUCPreprocessingToken.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//

#import "NUCLexicalElement.h"

@class NUCPreprocessor;
@class NSMutableArray, NSMutableString;

@interface NUCPreprocessingToken : NUCLexicalElement



- (void)addUnexpandedPpTokensTo:(NSMutableArray *)aPpTokens;
- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens;

@end

