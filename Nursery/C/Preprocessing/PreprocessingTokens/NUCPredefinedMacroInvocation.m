//
//  NUCPredefinedMacroInvocation.m
//  Nursery
//
//  Created by aki on 2023/08/31.
//

#import "NUCPredefinedMacroInvocation.h"
#import "NUCIdentifier.h"
#import "NUCPreprocessor.h"
#import "NUCSourceFile.h"
#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSString.h>

@implementation NUCPredefinedMacroInvocation

@synthesize identifier;

+ (instancetype)macroInvocationWithIdentifier:(NUCIdentifier *)anIdentifier parent:(NUCMacroInvocation *)aParent
{
    return [[[self alloc] initWithIdentifier:anIdentifier parent:aParent] autorelease];
}

- (instancetype)initWithIdentifier:(NUCIdentifier *)anIdentifier parent:(NUCMacroInvocation *)aParent
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        identifier = [anIdentifier retain];
    }
    
    return self;
}

- (void)dealloc
{
    [identifier release];
    
    [super dealloc];
}

- (BOOL)isMacroInvocation
{
    return YES;
}

- (NUCMacroInvocation *)top
{
    if ([self parent])
        return [[self parent] top];
    else
        return (NUCMacroInvocation *)self;
}

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens with:(NUCPreprocessor *)aPreprocessor
{
    if ([[self identifier] isEqualToString:NUCPredefinedMacroLINE])
    {
        NSUInteger aLineNumber = [[aPreprocessor sourceFile] lineNumberForLocation:[[[self top] identifier] range].location];
        NSString *aLineNumberString = [NSString stringWithFormat:@"%lu", aLineNumber];
        NUCDecomposedPreprocessingToken *aLinePpNumber = [NUCDecomposedPreprocessingToken preprocessingTokenWithContent:aLineNumberString range:NSMakeRange(NSNotFound, 0) type:NUCLexicalElementPpNumberType];
        [aPpTokens addObject:aLinePpNumber];
    }
}

@end
