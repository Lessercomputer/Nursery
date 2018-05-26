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
#import "NUCharacter.h"
#import "NUAliaser.h"

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

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    if (self = [super init])
    {
        capacity = numItems;
        objects = malloc(sizeof(id) * capacity);
    }
    
    return self;
}

- (instancetype)initWithObjects:(id  _Nonnull const [])anObjects count:(NSUInteger)aCount
{
    if (self = [super init])
    {
        if (aCount)
        {
            objects = malloc(sizeof(id) * aCount);
            
            for (NSUInteger i = 0; i < aCount; i++)
                objects[i] = [anObjects[i] retain];
            
            capacity = aCount;
            count = aCount;
        }
        else
        {
            capacity = 7;
            objects = malloc(sizeof(id) * capacity);
        }
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

- (NULazyMutableArray *)subLazyMutableArrayWithRange:(NSRange)aRange
{
    if (!aRange.length)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
    
    id *anObjects = malloc(sizeof(id) * aRange.length);
    
    [self getObjects:anObjects range:aRange];
    
    id aSubLazyMutableArray = [[[[self class] alloc] initWithObjects:anObjects count:aRange.length] autorelease];
    
    free(anObjects);
    
    return aSubLazyMutableArray;
}

+ (BOOL)automaticallyEstablishCharacter
{
    return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter setFormat:NUIndexedIvars];
}

- (Class)classForNursery
{
    return [NULazyMutableArray class];
}

- (NUUInt64)indexedIvarsSize
{
    return sizeof(NUUInt64) * [self count];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    [self encodeIndexedIvarsWithAliaser:anAliaser];
}

- (void)encodeIndexedIvarsWithAliaser:(NUAliaser *)anAliaser
{
    if (count)
    {
        [self loadObjects];
        
        [anAliaser encodeIndexedIvars:objects count:count];
    }
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    if (self = [super init])
    {
        NUUInt64 aSize = [anAliaser indexedIvarsSize];
        NUUInt64 aCount = aSize / sizeof(NUUInt64);
        
        if (aCount)
        {
            oops = malloc(sizeof(id) * aCount);
            
            [anAliaser decodeUInt64Array:oops count:aCount];

            objects = calloc(aCount, sizeof(id));
            count = aCount;
            capacity = aCount;
        }
    }
    
    return self;
}

- (void)moveUpWithAliaser:(NUAliaser *)anAliaser
{
    ;
}

@end
