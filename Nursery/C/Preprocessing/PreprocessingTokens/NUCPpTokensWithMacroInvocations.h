//
//  NUCPpTokensWithMacroInvocations.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/14.
//

#import "NUCPpTokens.h"


@interface NUCPpTokensWithMacroInvocations : NUCPpTokens
{
    NSUInteger overlappedMacroNameIndex;
}

- (NSUInteger)overlappedMacroNameIndex;
- (void)setOverlappedMacroNameIndex:(NSUInteger)anIndex;

@end

