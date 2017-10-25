//
//  NUMainBranchPlayLot.h
//  Nursery
//
//  Created by P,T,A on 2013/10/23.
//
//

#import <Nursery/Nursery.h>

@class NUMainBranchNursery, NUMainBranchAliaser;

@interface NUMainBranchPlayLot : NUPlayLot
{
    NSLock *farmOutLock;
}
@end

@interface NUMainBranchPlayLot (Private)

- (NUMainBranchNursery *)mainBranchNursery;
- (NUMainBranchAliaser *)mainBranchAliaser;
- (void)setNurseryRootOOP;

@end