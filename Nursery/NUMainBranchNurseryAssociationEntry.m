//
//  NUMainBranchNurseryAssociationEntry.m
//  Nursery
//
//  Created by P,T,A on 2013/12/25.
//
//

#import "NUMainBranchNurseryAssociationEntry.h"
#import "NUMainBranchPlayLot.h"

@implementation NUMainBranchNurseryAssociationEntry

+ (id)entryWithName:(NSString *)aName nursery:(NUMainBranchNursery *)aNursery
{
    return [[[self alloc] initWithName:aName nursery:aNursery] autorelease];
}

- (id)initWithName:(NSString *)aName nursery:(NUMainBranchNursery *)aNursery
{
    if (self = [super init])
    {
        lock = [NSLock new];
        name = [aName copy];
        nursery = [aNursery retain];
        playLots = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)close
{
    [playLots enumerateKeysAndObjectsUsingBlock:^(id key, NUPairedMainBranchPlayLot *aPlayLot, BOOL *stop) {
        [aPlayLot close];
    }];
}

- (NUMainBranchNursery *)nursery
{
    return nursery;
}

- (NUPairedMainBranchPlayLot *)playLotForID:(NUUInt64)anID
{
    @try {
        [lock lock];
        return [playLots objectForKey:@(anID)];
    }
    @finally {
        [lock unlock];
    }
}

- (void)setPlayLot:(NUPairedMainBranchPlayLot *)aPlayLot forID:(NUUInt64)anID
{
    @try {
        [lock lock];
        [playLots setObject:aPlayLot forKey:@(anID)];
    }
    @finally {
        [lock unlock];
    }
}

- (void)removePlayLotForID:(NUUInt64)anID
{
    @try {
        [lock lock];
        [playLots removeObjectForKey:@(anID)];
    }
    @finally {
        [lock unlock];
    }
}

- (void)dealloc
{
    [name release];
    [nursery release];
    [playLots release];
    [lock release];
    
    [super dealloc];
}

@end
