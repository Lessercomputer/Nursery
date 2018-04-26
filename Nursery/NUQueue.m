//
//  NUQueue.m
//  Nursery
//
//  Created by Akifumi Takata on 2017/11/27.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#include <stdlib.h>

#import "NUQueue.h"

const NUUInt64 NUQueueDefaultObjectsSize = 7;

@implementation NUQueue

+ (instancetype)queue
{
    return [[self new] autorelease];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        objectsSize = NUQueueDefaultObjectsSize;
        objects = malloc(sizeof(id) * objectsSize);
    }
    return self;
}

- (void)dealloc
{
    free(objects);
    
    [super dealloc];
}

- (void)push:(id)anObject
{
    if (count == objectsSize)
    {
        id *anObjects = objects;
        objectsSize = objectsSize * 2;
        objects = malloc(sizeof(id) * objectsSize);
        
        if (topIndex < bottomIndex)
        {
            NUUInt64 i = 0;
            for (NUUInt64 j = topIndex; j < bottomIndex; j++)
                objects[i++] = anObjects[j];
        }
        else
        {
            NUUInt64 i = 0;
            
            for (NUUInt64 j = topIndex; j < count; j++)
                objects[i++] = anObjects[j];

            for (NUUInt64 j = 0; j < bottomIndex; j++)
                objects[i++] = anObjects[j];
        }
        
        topIndex = 0;
        bottomIndex = count;
        
        free(anObjects);
    }
    else if (bottomIndex == objectsSize)
        bottomIndex = 0;
    
    objects[bottomIndex] = [anObject retain];
    
    bottomIndex++;
    
    count++;
}

- (id)pop
{
    if (!count) return nil;
    
    id anObject = [objects[topIndex] autorelease];
    objects[topIndex] = nil;
    
    topIndex++;
    
    if (topIndex == objectsSize && bottomIndex <= topIndex)
        topIndex = 0;
    
    count--;
    
    return anObject;
}

- (NUUInt64)count
{
    return count;
}

@end
