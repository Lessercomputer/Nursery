//
//  NUBranchAperture.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/09/19.
//
//

#import "NUAperture.h"

@class NUBranchNursery, NUBranchGarden, NUPupilNote;

@interface NUBranchAperture : NUAperture
{
    NUBranchNursery *nursery;
    NUBranchGarden *garden;
    NUPupilNote *pupilNote;
}
@end
