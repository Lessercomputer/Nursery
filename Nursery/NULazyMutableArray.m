//
//  NULazyMutableArray.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/05/22.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <stdlib.h>
#import <Foundation/NSException.h>

#import "NULazyMutableArray.h"
#import "NUBell.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"

@implementation NULazyMutableArray

- (instancetype)init
{
    if (self = [super init])
    {
        capacity = 7;
        objects = malloc(sizeof(id) * capacity);
    }
    
    return self;
}

- (void)dealloc
{
    free(objects);
    free(oops);
    
    [super dealloc];
}

- (NSUInteger)count
{
    return count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    if (index >= count)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];

    if (!oops)
        return objects[index];
    
    id anObject = objects[index];
    
    if (!anObject)
    {
        NUUInt64 anOOP = oops[index];
        anObject = [[[self bell] garden] objectForOOP:anOOP];
        objects[index] = [anObject retain];
    }
    
    return anObject;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (index > count || !anObject)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];

    [self loadObjects];
    
    if (capacity <= count)
        [self grow];
    
    if (count && index < count)
    {
        NSUInteger anIndexToMove = count - 1;
        
        while (YES)
        {
            objects[anIndexToMove + 1] = objects[anIndexToMove];
            
            if (anIndexToMove > index)
                anIndexToMove--;
            else
                break;
        }
    }
    
    objects[index] = [anObject retain];
    count++;
}

- (void)grow
{
    NSUInteger aNewCapacity = capacity * 2;
    id *aNewObjects = malloc(sizeof(id) * aNewCapacity);
    NSUInteger anIndex = 0;
    
    for (; anIndex < count; anIndex++)
        aNewObjects[anIndex] = objects[anIndex];
    
    free(objects);
    objects = aNewObjects;
    capacity = aNewCapacity;
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    if (index >= count)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
    
    [self loadObjects];
    
    [objects[index] release];
    
    for (NSUInteger i = index; i < count; i++)
    {
        objects[i] = objects[i + 1];
    }
    
    count--;
}

- (void)loadObjects
{
    if (oops)
    {
        for (NSUInteger i = 0; i < count; i++)
            if (!objects[i])
                objects[i] = [[[[self bell] garden] objectForOOP:oops[i]] retain];
        
        free(oops);
        oops = NULL;
    }
}

- (void)addObject:(id)anObject
{
    [self insertObject:anObject atIndex:count];
}

-  (void)removeLastObject
{
    if (count)
        [self removeObjectAtIndex:count - 1];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= count)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
    
    [self loadObjects];
    
    [anObject retain];
    [objects[index] release];
    objects[index] = anObject;
}

@end
