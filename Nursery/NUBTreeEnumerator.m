//
//  NUTreeEnumerator.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/02/14.
//
//

#import "NUBTreeEnumerator.h"
#import "NUBTree.h"
#import "NUBTreeLeaf.h"

@implementation NUBTreeEnumerator

+ (id)enumeratorWithTree:(NUBTree *)aTree keyGreaterThanOrEqualTo:(id)aKey1 keyLessThanOrEqualTo:(id)aKey2 options:(NSEnumerationOptions)anOpts;
{
    return [[[self alloc] initWithTree:aTree keyGreaterThanOrEqualTo:aKey1 keyLessThanOrEqualTo:aKey2 options:anOpts] autorelease];
}

+ (id)enumeratorWithTree:(NUBTree *)aTree keyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 keyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts
{
    return [[[self alloc] initWithTree:aTree keyGreaterThan:aKey1 orEqual:anOrEqualFlag1 keyLessThan:aKey2 orEqual:anOrEqualFlag2 options:anOpts] autorelease];
}

- (id)initWithTree:(NUBTree *)aTree keyGreaterThanOrEqualTo:(id)aKey1 keyLessThanOrEqualTo:(id)aKey2 options:(NSEnumerationOptions)anOpts
{
    return [self initWithTree:aTree keyGreaterThan:aKey1 orEqual:YES keyLessThan:aKey2 orEqual:YES options:anOpts];
}

- (id)initWithTree:(NUBTree *)aTree keyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 keyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts
{
    self = [super init];
    
    if (self)
    {
        tree = [aTree retain];
        key1 = [aKey1 retain];
        key2 = [aKey2 retain];
        
        orEqualFlag1 = anOrEqualFlag1;
        orEqualFlag2 = anOrEqualFlag2;
        
        options = anOpts;
        
        if (key1 && key2 && [[tree comparator] compareObject:key1 toObject:key2] == NSOrderedDescending)
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
        
        NUUInt64 aTmpNextValueIndex = 0;
        
        if ((anOpts & NSEnumerationReverse) != NSEnumerationReverse)
        {
            if (key1)
            {
                if (anOrEqualFlag1)
                    node = [[tree leafNodeContainingKeyGreaterThanOrEqualTo:key1 keyIndex:&aTmpNextValueIndex] retain];
                else
                    node = [[tree leafNodeContainingKeyGreaterThan:key1 keyIndex:&aTmpNextValueIndex] retain];
            }
            else
                node = [[tree firstLeaf] retain];
        }
        else
        {
            if (key2)
            {
                if (anOrEqualFlag2)
                    node = [[tree leafNodeContainingKeyLessThanOrEqualTo:key2 keyIndex:&aTmpNextValueIndex] retain];
                else
                    node = [[tree leafNodeContainingKeyLessThan:key2 keyIndex:&aTmpNextValueIndex] retain];
            }
            else
            {
                node = [[tree lastLeaf] retain];
                aTmpNextValueIndex = (NUInt32)[node valueCount] - 1;
            }
        }
        
        nextValueIndex = aTmpNextValueIndex;
    }
    
    return self;
}

- (void)dealloc
{
    [tree release];
    [key1 release];
    [key2 release];
    [node release];
    
    [super dealloc];
}

- (id)nextObject
{
    __block id nextObject = nil;
        
    [self enumerateKeysAndObjectsUsingBlock:^(id aKey, id anObj, BOOL *aStop) {
        nextObject = anObj;
        *aStop = YES;
    }];
    
    return nextObject;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock
{
    BOOL aStop = NO;

    if ((options & NSEnumerationReverse) != NSEnumerationReverse)
    {
        while (!aStop)
        {
            @autoreleasepool
            {
                if (nextValueIndex >= [node valueCount])
                {
                    [node autorelease];
                    node = (NUBTreeLeaf *)[[node rightNode] retain];
                    nextValueIndex = 0;
                }
                
                if (node && (!key2
                             || (orEqualFlag2 && [[tree comparator] compareObject:[node keyAt:nextValueIndex] toObject:key2] != NSOrderedDescending)
                             || (!orEqualFlag2 && [[tree comparator] compareObject:[node keyAt:nextValueIndex] toObject:key2] == NSOrderedAscending)))
                {
                    aBlock([node keyAt:nextValueIndex], [node valueAt:nextValueIndex], &aStop);
                    nextValueIndex++;
                }
                else
                    aStop = YES;
            }
        }
    }
    else
    {
        while (!aStop)
        {
            @autoreleasepool
            {
                if (nextValueIndex < 0)
                {
                    [node autorelease];
                    node = (NUBTreeLeaf *)[[node leftNode] retain];
                    nextValueIndex = (NUInt32)[node valueCount] - 1;
                }
                
                if (node && (!key1
                             || (orEqualFlag1 && [[tree comparator] compareObject:[node keyAt:nextValueIndex] toObject:key1] != NSOrderedAscending)
                             || (!orEqualFlag1 && [[tree comparator] compareObject:[node keyAt:nextValueIndex] toObject:key1] == NSOrderedDescending)))
                {
                    aBlock([node keyAt:nextValueIndex], [node valueAt:nextValueIndex], &aStop);
                    nextValueIndex--;
                }
                else
                    aStop = YES;
            }
        }
    }
}

@end
