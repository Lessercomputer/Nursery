//
//  NUCLine.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2022/03/28.
//

#import "NUCLine.h"
#import "NUCPreprocessor.h"
#import "NUCPpTokens.h"
#import "NUCDecomposer.h"

@implementation NUCLine

+ (instancetype)lineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline
{
    if (self = [super initWithType:NUCLexicalElementLineType hash:aHash directiveName:aDirectiveName newline:aNewline])
    {
        ppTokens = [aPpTokens retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

- (NUCPpTokens *)ppTokens
{
    return ppTokens;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    NUCPpTokens *aPptokens = [NUCPpTokens ppTokensWithMacroInvocationsFromPpTokens:[self ppTokens] with:aPreprocessor];
    NSMutableArray *aMacroReplacedPpTokens = [aPptokens replaceMacrosWith:aPreprocessor];
    
//    [NUCDecomposer scanDigitSequenceFrom:<#(NSScanner *)#> into:<#(NSString **)#>]
    [aPreprocessor line:self];

}

@end
