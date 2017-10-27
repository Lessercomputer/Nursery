//
//  NUBranchAperture.h
//  Nursery
//
//  Created by P,T,A on 2013/09/19.
//
//

#import "NUAperture.h"

@class NUBranchNursery, NUBranchSandbox, NUPupilNote;

@interface NUBranchAperture : NUAperture
{
    NUBranchNursery *nursery;
    NUBranchSandbox *sandbox;
    NUPupilNote *pupilNote;
}
@end
