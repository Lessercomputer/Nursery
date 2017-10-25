//
//  NUTreeEnumerator.m
//  Nursery
//
//  Created by P,T,A on 2013/02/14.
//
//

#import <Nursery/NUBTreeEnumerator.h>
#import <Nursery/NUBTree.h>
#import <Nursery/NUBTreeLeaf.h>

@implementation NUBTreeEnumerator

+ (id)enumeratorWithTree:(NUBTree *)aTree;
{
    return [[[self alloc] initWithTree:aTree] autorelease];
}

- (id)initWithTree:(NUBTree *)aTree
{
    [super init];

    tree = [aTree retain];
    node = [[aTree firstLeaf] retain];
    
    return self;
}

- (void)dealloc
{
    [tree release];
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

    while (!aStop)
    {
        @autoreleasepool
        {
            if (nextValueIndex >= [node valueCount])
            {
                node = (NUBTreeLeaf *)[node rightNode];
                nextValueIndex = 0;
            }
            
            if (node)
            {
                aBlock([node keyAt:nextValueIndex], [node valueAt:nextValueIndex], &aStop);
                nextValueIndex++;
            }
            else
                aStop = YES;
        }
    }
}

@end
