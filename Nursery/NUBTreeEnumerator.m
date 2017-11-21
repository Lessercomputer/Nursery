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

- (id)initWithTree:(NUBTree *)aTree keyGreaterThanOrEqualTo:(id)aKey1 keyLessThanOrEqualTo:(id)aKey2 options:(NSEnumerationOptions)anOpts
{
    [super init];

    tree = [aTree retain];
    keyFrom = [aKey1 retain];
    keyTo = [aKey2 retain];
    
    options = anOpts;
    
    if (keyFrom && keyTo && [[tree comparator] compareObject:keyFrom toObject:keyTo] != NSOrderedAscending)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
    
    NUUInt64 aTmpNextValueIndex = 0;
    
    if ((anOpts & NSEnumerationReverse) != NSEnumerationReverse)
    {
        if (keyFrom)
            node = [[tree leafNodeContainingKeyGreaterThanOrEqualTo:keyFrom keyIndex:&aTmpNextValueIndex] retain];
        else
            node = [[tree firstLeaf] retain];
    }
    else
    {
        if (keyTo)
        {
            node = [[tree leafNodeContainingKeyLessThanOrEqualTo:keyTo keyIndex:&aTmpNextValueIndex] retain];
        }
        else
        {
            node = [[tree lastLeaf] retain];
            aTmpNextValueIndex = (NUInt32)[node valueCount] - 1;
        }
    }
    
    nextValueIndex = aTmpNextValueIndex;
    
    return self;
}

- (void)dealloc
{
    [tree release];
    [keyFrom release];
    [keyTo release];
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
                    node = (NUBTreeLeaf *)[node rightNode];
                    nextValueIndex = 0;
                }
                
                if (node && (!keyTo || [[tree comparator] compareObject:[node keyAt:nextValueIndex] toObject:keyTo] != NSOrderedDescending))
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
                    node = (NUBTreeLeaf *)[node leftNode];
                    nextValueIndex = (NUInt32)[node valueCount] - 1;
                }
                
                if (node && (!keyFrom || [[tree comparator] compareObject:[node keyAt:nextValueIndex] toObject:keyFrom] != NSOrderedAscending))
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
