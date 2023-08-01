//
//  NUObjectTableLeaf.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/17.
//

#import "NUOpaqueBPlusTreeLeaf.h"


@interface NUObjectTableLeaf : NUOpaqueBPlusTreeLeaf
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
