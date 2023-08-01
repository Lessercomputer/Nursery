//
//  NULocationTreeLeaf.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/17.
//

#import "NUOpaqueBPlusTreeLeaf.h"


@interface NULocationTreeLeaf : NUOpaqueBPlusTreeLeaf
{

}

- (NURegion)regionAt:(NUUInt32)anIndex;

@end
