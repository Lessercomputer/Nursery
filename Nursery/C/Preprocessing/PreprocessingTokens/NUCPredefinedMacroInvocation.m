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
#import "NUCStringLiteral.h"

#import <Foundation/NSString.h>
#import <Foundation/NSDate.h>
#import <Foundation/NSDateFormatter.h>
#import <Foundation/NSCalendar.h>
#import <Foundation/NSLocale.h>

@implementation NUCPredefinedMacroInvocation

@synthesize identifier;
@synthesize parent;

+ (BOOL)identifierIsPredefined:(NUCIdentifier *)anIdentifier
{
    return [anIdentifier isEqualToString:NUCPredefinedMacroLINE]
            || [anIdentifier isEqualToString:NUCPredefinedMacroFILE]
            || [anIdentifier isEqualToString:NUCPredefinedMacroDATE]
            || [anIdentifier isEqualToString:NUCPredefinedMacroTIME];
}

+ (instancetype)macroInvocationWithIdentifier:(NUCIdentifier *)anIdentifier parent:(NUCMacroInvocation *)aParent
{
    return [[[self alloc] initWithIdentifier:anIdentifier parent:aParent] autorelease];
}

- (instancetype)initWithIdentifier:(NUCIdentifier *)anIdentifier parent:(NUCMacroInvocation *)aParent
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        identifier = [anIdentifier retain];
        parent = aParent;
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
    NUCIdentifier *anIdentifier = [self identifier];
    
    if ([anIdentifier isEqualToString:NUCPredefinedMacroLINE])
    {
        NSUInteger aLineNumber = [[aPreprocessor sourceFile] lineNumberForLocation:[[[self top] identifier] range].location];
        NSString *aLineNumberString = [NSString stringWithFormat:@"%lu", aLineNumber];
        NUCDecomposedPreprocessingToken *aLinePpNumber = [NUCDecomposedPreprocessingToken preprocessingTokenWithContent:aLineNumberString range:NSMakeRange(NSNotFound, 0) type:NUCLexicalElementPpNumberType];
        [aPpTokens addObject:aLinePpNumber];
    }
    else if ([anIdentifier isEqualToString:NUCPredefinedMacroFILE])
    {
        NSString *aFilepath = [[aPreprocessor sourceFile] file];
        NUCStringLiteral *aStringLiteral = [NUCStringLiteral preprocessingTokenWithContent:aFilepath range:NSMakeRange(NSNotFound, 0) type:NUCLexicalElementStringLiteralType];
        [aPpTokens addObject:aStringLiteral];
    }
    else if ([anIdentifier isEqualToString:NUCPredefinedMacroDATE])
    {
        NSDate *aDate = [NSDate date];
        NSDateFormatter *aDateFormatter = [[NSDateFormatter new] autorelease];
        [aDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [aDateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
        NSInteger aYear, aDay;
        [[aDateFormatter calendar] getEra:NULL year:&aYear month:NULL day:&aDay fromDate:aDate];
        [aDateFormatter setLocalizedDateFormatFromTemplate:@"MMM"];
        
        NSString *aTimeString = [NSString stringWithFormat:@"%@ %2ld %ld", [aDateFormatter stringFromDate:aDate], aDay, aYear];
        
        NUCStringLiteral *aStringLiteral = [NUCStringLiteral preprocessingTokenWithContent:aTimeString range:NSMakeRange(NSNotFound, 0) type:NUCLexicalElementStringLiteralType];
        
        [aPpTokens addObject:aStringLiteral];
    }
    else if ([anIdentifier isEqualToString:NUCPredefinedMacroTIME])
    {
        NSDateFormatter *aDateFormatter = [[NSDateFormatter new] autorelease];
        [aDateFormatter setLocalizedDateFormatFromTemplate:@"HH:mm:ss"];
        NSString *aTimeString = [aDateFormatter stringFromDate:[NSDate date]];
        
        NUCStringLiteral *aStringLiteral = [NUCStringLiteral preprocessingTokenWithContent:aTimeString range:NSMakeRange(NSNotFound, 0) type:NUCLexicalElementStringLiteralType];
        
        [aPpTokens addObject:aStringLiteral];
    }
}

@end
