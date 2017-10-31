//
//  NUMainBranchSandbox.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import <Nursery/Nursery.h>

@class NUMainBranchNursery, NUMainBranchAliaser;

@interface NUMainBranchSandbox : NUSandbox
{
    NSLock *farmOutLock;
}
@end

@interface NUMainBranchSandbox (Private)

- (NUMainBranchNursery *)mainBranchNursery;
- (NUMainBranchAliaser *)mainBranchAliaser;
- (void)setNurseryRootOOP;

@end
