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

- (void)addElementAtFirst:(NULinkedListElement *)anElement
{
    [self addElement:anElement previousTo:first];
}

- (void)moveToFirst:(NULinkedListElement *)anElement
{
    if (!anElement || ![elements containsObject:anElement])
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
    
    [anElement retain];
    [self remove:anElement];
    [self addElement:anElement previousTo:first];
    [anElement release];
}

- (void)addElement:(NULinkedListElement *)anElementToAdd previousTo:(NULinkedListElement *)anElement
{
    if (anElement && ![self contains:anElement])
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
    
    [elements addObject:anElementToAdd];

    if (!anElement)
    {
        first = anElementToAdd;
        last = anElementToAdd;
    }
    else if (anElement == first && anElement == last)
    {
        first = anElementToAdd;
        [anElementToAdd setNext:anElement];
        [anElement setPrevious:anElementToAdd];
    }
    else if (anElement == first)
    {
        first = anElementToAdd;
        [anElementToAdd setNext:anElement];
        [anElement setPrevious:anElementToAdd];
    }
    else if (anElement == last)
    {
        [anElement setPrevious:anElementToAdd];
        [anElementToAdd setNext:anElement];
    }
}

- (void)remove:(NULinkedListElement *)anElement
{
    if (!anElement) return;
    
    if ([anElement previous] && [anElement next])
    {
        [[anElement previous] setNext:[anElement next]];
        [[anElement next] setPrevious:[anElement previous]];
    }
    else if ([anElement previous])
    {
        [[anElement previous] setNext:nil];
        last = [anElement previous];
    }
    else if ([anElement next])
    {
        [[anElement next] setPrevious:nil];
        first = [anElement next];
    }
    else
    {
        first = nil;
        last = nil;
    }
    
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
