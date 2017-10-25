//
//  NUMainBranchNurseryAssociationEntry.h
//  Nursery
//
//  Created by P,T,A on 2013/12/25.
//
//

#import <Nursery/NUTypes.h>

@class NUMainBranchNursery, NUPairedMainBranchPlayLot;

@interface NUMainBranchNurseryAssociationEntry : NSObject
{
    NSString *name;
    NUMainBranchNursery *nursery;
    NSMutableDictionary *playLots;
    NSLock *lock;
}

+ (id)entryWithName:(NSString *)aName nursery:(NUMainBranchNursery *)aNursery;

- (id)initWithName:(NSString *)aName nursery:(NUMainBranchNursery *)aNursery;

- (void)close;

- (NUMainBranchNursery *)nursery;
- (NUPairedMainBranchPlayLot *)playLotForID:(NUUInt64)anID;
- (void)setPlayLot:(NUPairedMainBranchPlayLot *)aPlayLot forID:(NUUInt64)anID;
- (void)removePlayLotForID:(NUUInt64)anID;

@end
