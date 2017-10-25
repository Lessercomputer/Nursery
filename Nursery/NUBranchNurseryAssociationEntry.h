//
//  NUBranchNurseryAssociationEntry.h
//  Nursery
//
//  Created by P,T,A on 2013/12/20.
//
//

@class NUBranchNursery, NUPlayLot, NUBranchPlayLot;

@interface NUBranchNurseryAssociationEntry : NSObject
{
    NSURL *associationURL;
    NSMutableDictionary *nurseries;
    NSMutableDictionary *connections;
    NSLock *lock;
}

+ (id)entryWithURL:(NSURL *)aURL;

- (id)initWithURL:(NSURL *)aURL;

- (NUBranchNursery *)nurseryForURL:(NSURL *)aURL;
- (void)setNursery:(NUBranchNursery *)aNursery forURL:(NSURL *)aURL;
- (NSMutableDictionary *)nurseries;

- (NSMutableDictionary *)connections;

- (void)close;

@end
