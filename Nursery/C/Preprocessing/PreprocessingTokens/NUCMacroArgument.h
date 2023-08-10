//
//  NUCMacroArgument.h
//  Nursery
//
//  Created by aki on 2023/08/04.
//

#import "NUCPreprocessingToken.h"

@class NSMutableArray, NSMutableString;

@interface NUCMacroArgument : NUCPreprocessingToken
{
    NSMutableArray *argument;
}

+ (instancetype)argument;

- (NSMutableArray *)argument;

- (void)add:(NUCPreprocessingToken *)aPpToken;

- (BOOL)isPlacemaker;

- (NSArray *)ppTokensByTrimingWhitespaces;

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces;

- (void)addStringForConcatinationTo:(NSMutableString *)aString;

@end
