//
//  NULinkedList.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSSet.h>
#import <Foundation/NSException.h>

#import "NULinkedList.h"
#import "NULinkedListElement.h"

@implementation NULinkedList

- (instancetype)init
{
    if (self = [super init])
    {
        elements = [NSMutableSet new];
    }
    
    return self;
}

- (void)dealloc
{
    [elements release];
    elements = nil;
    
    [super dealloc];
}

- (NULinkedListElement *)first
{
    return first;
}

- (NULinkedListElement *)last
{
    return last;
}

- (NUUInt64)count
{
    return [elements count];
}

- (BOOL)contains:(NULinkedListElement *)anElement
{
    return [elements containsObject:anElement];
}

- (void)addElementToFirst:(NULinkedListElement *)anElement
{
    if ([elements containsObject:anElement])
        return;
    
    [elements addObject:anElement];
    [self moveToFirst:anElement];
}

- (void)moveToFirst:(NULinkedListElement *)anElement
{
    if (!anElement || ![elements containsObject:anElement])
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
    
    if (first && [first isEqual:anElement])
        return;
    
    if ([anElement previous] && [anElement next])
    {
        [[anElement previous] setNext:[anElement next]];
        [[anElement next] setPrevious:[anElement previous]];
        
        [anElement setPrevious:nil];
        [anElement setNext:first];
        first = anElement;
    }
    else if ([anElement previous])
    {
        [[anElement previous] setNext:nil];
    }
    else if ([anElement next])
    {
        [[anElement next] setPrevious:nil];
    }
    else
    {
        if (first)
        {
            [anElement setNext:first];
            [first setPrevious:anElement];
            first = anElement;
        }
        else
        {
            first = anElement;
            last = anElement;
        }
    }
}

- (void)remove:(NULinkedListElement *)anElement
{
    if (!anElement) return;
    
    if ([anElement isEqual:first]) first = [anElement next];
    if ([anElement isEqual:last]) last = [anElement previous];

    [[anElement previous] setNext:[anElement next]];
    [[anElement next] setPrevious:[anElement previous]];

    [anElement setPrevious:nil];
    [anElement setNext:nil];
    [elements removeObject:anElement];
}

- (void)removeLast
{
    if (![self count]) return;
    
    [self remove:last];
}

@end
