//
//  NUMainBranchPeephole.h
//  Nursery
//
//  Created by P,T,A on 2013/09/19.
//
//

#import "NUPeephole.h"

@class NUMainBranchNursery, NUMainBranchPlayLot;

@interface NUMainBranchPeephole : NUPeephole
{
    NUMainBranchNursery *nursery;
    NUMainBranchPlayLot *playLot;
	NUUInt64 oop;
	NUUInt64 objectLocation;
}
@end
