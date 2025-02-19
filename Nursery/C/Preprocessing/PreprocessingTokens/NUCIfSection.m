//
//  NUCIfSection.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCIfSection.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCIfGroup.h"
#import "NUCElifGroups.h"
#import "NUCElseGroup.h"
#import "NUCEndifLine.h"

@implementation NUCIfSection

+ (BOOL)ifSectionFrom:(NUCPreprocessingTokenStream *)aStream  with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCPreprocessingDirective **)anIfSection
{
    NSUInteger aPosition = [aStream position];
    NUCIfGroup *anIfGroup = nil;
    NUCElifGroups *anElifGroups = nil;
    NUCElseGroup *anElseGroup = nil;
    NUCEndifLine *anEndifLine = nil;
    
    if ([NUCIfGroup ifGroupFrom:aStream with:aPreprocessor isSkipped:aGroupIsSkipped into:&anIfGroup])
    {
        [NUCElifGroups elifGroupsFrom:aStream with:aPreprocessor isSkipped:(aGroupIsSkipped || ![anIfGroup isSkipped]) into:&anElifGroups];
        
        [NUCElseGroup elseGroupFrom:aStream with:aPreprocessor isSkipped:(aGroupIsSkipped || ![anIfGroup isSkipped] || ![anElifGroups isSkipped]) into:&anElseGroup];
        
        if ([NUCEndifLine endifLineFrom:aStream into:&anEndifLine])
        {
            if (anIfSection)
            {
                *anIfSection = [NUCIfSection ifSectionWithIfGroup:anIfGroup elifGroups:anElifGroups elseGroup:anElseGroup endifLine:anEndifLine];
                if (aGroupIsSkipped)
                    [(NUCIfSection *)*anIfSection setIsSkipped:YES];
            }
            
            return YES;
        }
        else
            [aStream setPosition:aPosition];
    }
    
    return NO;
}

+ (instancetype)ifSectionWithIfGroup:(NUCIfGroup *)anIfGroup elifGroups:(NUCElifGroups *)anElifGroups elseGroup:(NUCElseGroup *)anElseGroup endifLine:(NUCEndifLine *)anEndifLine
{
    return [[[self alloc] initWithIfGroup:anIfGroup elifGroups:anElifGroups elseGroup:anElseGroup endifLine:anEndifLine] autorelease];
}

- (instancetype)initWithIfGroup:(NUCIfGroup *)anIfGroup elifGroups:(NUCElifGroups *)anElifGroups elseGroup:(NUCElseGroup *)anElseGroup endifLine:(NUCEndifLine *)anEndifLine
{
    if (self = [super initWithType:NUCLexicalElementIfSectionType])
    {
        ifGroup = [anIfGroup retain];
        elifGroups = [anElifGroups retain];
        elseGroup = [anElseGroup retain];
        endifLine = [anEndifLine retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ifGroup release];
    [elifGroups release];
    [elseGroup release];
    [endifLine release];
    
    [super dealloc];
}

- (NUCIfGroup *)ifGroup
{
    return ifGroup;
}

- (NUCElifGroups *)elifGroups
{
    return elifGroups;
}

- (NUCElseGroup *)elseGroup
{
    return elseGroup;
}

- (NUCEndifLine *)endifLine
{
    return endifLine;
}

- (void)addPpTokensByReplacingMacrosTo:(NSMutableArray *)aMacroReplacedPpTokens with:(NUCPreprocessor *)aPreprocessor
{
    if ([self ifGroup] && ![[self ifGroup] isSkipped])
        [[self ifGroup] addPpTokensByReplacingMacrosTo:aMacroReplacedPpTokens with:aPreprocessor];
    if ([self elifGroups] && ![[self elifGroups] isSkipped])
        [[self elifGroups] addPpTokensByReplacingMacrosTo:aMacroReplacedPpTokens with:aPreprocessor];
    if ([self elseGroup] && ![[self elseGroup] isSkipped])
        [[self elseGroup] addPpTokensByReplacingMacrosTo:aMacroReplacedPpTokens with:aPreprocessor];
}

@end
