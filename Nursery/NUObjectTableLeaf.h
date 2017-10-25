//
//  NUObjectTableLeaf.h
//  Nursery
//
//  Created by P,T,A on 10/10/17.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUOpaqueBTreeLeaf.h>


@interface NUObjectTableLeaf : NUOpaqueBTreeLeaf
{
	NUOpaqueArray *gcMarks;
}

- (NUOpaqueArray *)makeGCMarks;

- (NUOpaqueArray *)gcMarks;
- (void)setGCMarks:(NUOpaqueArray *)aGCMarks;

- (NUUInt8)newGCMark;

- (NUUInt8)gcMarkAt:(NUUInt32)anIndex;
- (void)setGCMark:(NUUInt8)aMark at:(NUUInt32)anIndex;
- (void)removeAllGCMarks;

@end
