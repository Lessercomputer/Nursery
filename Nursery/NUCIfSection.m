//
//  NUCIfSection.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCIfSection.h"

@implementation NUCIfSection

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

@end
