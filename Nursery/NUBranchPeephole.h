//
//  NUBranchPeephole.h
//  Nursery
//
//  Created by P,T,A on 2013/09/19.
//
//

#import "NUPeephole.h"

@class NUBranchNursery, NUBranchPlayLot, NUPupilNote;

@interface NUBranchPeephole : NUPeephole
{
    NUBranchNursery *nursery;
    NUBranchPlayLot *playLot;
    NUPupilNote *pupilNote;
}
@end
