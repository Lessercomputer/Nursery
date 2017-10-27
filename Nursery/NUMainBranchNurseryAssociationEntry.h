//
//  NUMainBranchNurseryAssociationEntry.h
//  Nursery
//
//  Created by P,T,A on 2013/12/25.
//
//

#import <Nursery/NUTypes.h>

@class NUMainBranchNursery, NUPairedMainBranchSandbox;

@interface NUMainBranchNurseryAssociationEntry : NSObject
{
    NSString *name;
    NUMainBranchNursery *nursery;
    NSMutableDictionary *sandboxs;
    NSLock *lock;
}

+ (id)entryWithName:(NSString *)aName nursery:(NUMainBranchNursery *)aNursery;

- (id)initWithName:(NSString *)aName nursery:(NUMainBranchNursery *)aNursery;

- (void)close;

- (NUMainBranchNursery *)nursery;
- (NUPairedMainBranchSandbox *)sandboxForID:(NUUInt64)anID;
- (void)setSandbox:(NUPairedMainBranchSandbox *)aSandbox forID:(NUUInt64)anID;
- (void)removeSandboxForID:(NUUInt64)anID;

@end
