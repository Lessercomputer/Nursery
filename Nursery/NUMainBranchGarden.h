//
//  NUMainBranchGarden.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import "NUGarden.h"

@class NUMainBranchNursery, NUMainBranchAliaser;

@interface NUMainBranchGarden : NUGarden
{
    NSLock *farmOutLock;
}
@end

@interface NUMainBranchGarden (SaveAndLoad)

- (NUFarmOutStatus)farmOut;

@end

@interface NUMainBranchGarden (Private)

- (NUMainBranchNursery *)mainBranchNursery;
- (NUMainBranchAliaser *)mainBranchAliaser;
- (void)setNurseryRootOOP;

@end
