//
//  NULocationTreeLeaf.h
//  Nursery
//
//  Created by P,T,A on 10/10/17.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUOpaqueBTreeLeaf.h>


@interface NULocationTreeLeaf : NUOpaqueBTreeLeaf
{

}

- (NURegion)regionAt:(NUUInt32)anIndex;

@end
