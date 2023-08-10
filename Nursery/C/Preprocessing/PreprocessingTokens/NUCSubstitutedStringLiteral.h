//
//  NUCSubstitutedStringLiteral.h
//  Nursery
//
//  Created by aki on 2023/07/07.
//

#import "NUCPreprocessingToken.h"

@class NSMutableString;
@class NUCMacroArgument;

@interface NUCSubstitutedStringLiteral : NUCPreprocessingToken
{
    NUCMacroArgument *macroArgument;
    NSString *string;
}

+ (instancetype)substitutedStringLiteralWithMacroArgument:(NUCMacroArgument *)aMacroArgument;

- (instancetype)initWithMacroArgument:(NUCMacroArgument *)aMacroArgument;

- (NUCMacroArgument *)macroArgument;

- (NSString *)string;
- (void)addStringForConcatinationTo:(NSMutableString *)aString;

@end

