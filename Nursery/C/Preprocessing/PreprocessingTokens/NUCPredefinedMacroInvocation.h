//
//  NUCPredefinedMacroInvocation.h
//  Nursery
//
//  Created by aki on 2023/08/31.
//

#import "NUCPreprocessingToken.h"

@class NUCIdentifier, NUCMacroInvocation;

@interface NUCPredefinedMacroInvocation : NUCPreprocessingToken

@property (nonatomic, retain) NUCIdentifier *identifier;
@property (nonatomic, assign) NUCMacroInvocation *parent;
@property (nonatomic, readonly) NUCMacroInvocation *top;

+ (BOOL)identifierIsPredefined:(NUCIdentifier *)anIdentifier;

+ (instancetype)macroInvocationWithIdentifier:(NUCIdentifier *)anIdentifier parent:(NUCMacroInvocation *)aParent;

- (instancetype)initWithIdentifier:(NUCIdentifier *)anIdentifier parent:(NUCMacroInvocation *)aParent;

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens with:(NUCPreprocessor *)aPreprocessor;

@end

