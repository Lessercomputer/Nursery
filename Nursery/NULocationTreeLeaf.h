//
//  NULocationTreeLeaf.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/17.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUOpaqueBPlusTreeLeaf.h"


@interface NULocationTreeLeaf : NUOpaqueBPlusTreeLeaf
{

}

- (NURegion)regionAt:(NUUInt32)anIndex;

@end
