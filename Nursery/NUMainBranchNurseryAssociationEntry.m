//
//  NUMainBranchNurseryAssociationEntry.m
//  Nursery
//
//  Created by P,T,A on 2013/12/25.
//
//

#import "NUMainBranchNurseryAssociationEntry.h"
#import "NUMainBranchSandbox.h"

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
        sandboxs = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)close
{
    [sandboxs enumerateKeysAndObjectsUsingBlock:^(id key, NUPairedMainBranchSandbox *aSandbox, BOOL *stop) {
        [aSandbox close];
    }];
}

- (NUMainBranchNursery *)nursery
{
    return nursery;
}

- (NUPairedMainBranchSandbox *)sandboxForID:(NUUInt64)anID
{
    @try {
        [lock lock];
        return [sandboxs objectForKey:@(anID)];
    }
    @finally {
        [lock unlock];
    }
}

- (void)setSandbox:(NUPairedMainBranchSandbox *)aSandbox forID:(NUUInt64)anID
{
    @try {
        [lock lock];
        [sandboxs setObject:aSandbox forKey:@(anID)];
    }
    @finally {
        [lock unlock];
    }
}

- (void)removeSandboxForID:(NUUInt64)anID
{
    @try {
        [lock lock];
        [sandboxs removeObjectForKey:@(anID)];
    }
    @finally {
        [lock unlock];
    }
}

- (void)dealloc
{
    [name release];
    [nursery release];
    [sandboxs release];
    [lock release];
    
    [super dealloc];
}

@end
