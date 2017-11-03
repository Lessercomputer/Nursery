//
//  NUBranchNurseryAssociationEntry.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/12/20.
//
//

#import "NUBranchNurseryAssociationEntry.h"
#import "NUBranchSandbox.h"

@implementation NUBranchNurseryAssociationEntry

+ (id)entryWithURL:(NSURL *)aURL
{
    return [[[self alloc] initWithURL:aURL] autorelease];
}

- (id)initWithURL:(NSURL *)aURL
{
    if (self = [super init])
    {
        lock = [NSLock new];
        associationURL = [aURL copy];
        nurseries = [NSMutableDictionary new];
        connections = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [associationURL release];
    [nurseries release];
    [connections release];
    [lock release];
    
    [super dealloc];
}

- (NUBranchNursery *)nurseryForURL:(NSURL *)aURL
{
    return [[self nurseries] objectForKey:aURL];
}

- (void)setNursery:(NUBranchNursery *)aNursery forURL:(NSURL *)aURL
{
    [[self nurseries] setObject:aNursery forKey:aURL];
}

- (NSMutableDictionary *)nurseries
{
    return nurseries;
}

- (NSMutableDictionary *)connections
{
    return connections;
}

- (void)close
{
    [nurseries enumerateKeysAndObjectsUsingBlock:^(id key, NUBranchNursery *aNursery, BOOL *stop) {
        [aNursery close];
    }];
    [connections enumerateKeysAndObjectsUsingBlock:^(id key, NSConnection *aConnection, BOOL *stop) {
        [aConnection invalidate];
    }];
}

@end
