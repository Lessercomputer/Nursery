//
//  NUMainBranchAperture.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/09/19.
//
//

#import "NUAperture.h"

@class NUMainBranchNursery, NUMainBranchGarden;

@interface NUMainBranchAperture : NUAperture
{
    NUMainBranchNursery *nursery;
    NUMainBranchGarden *garden;
	NUUInt64 oop;
	NUUInt64 objectLocation;
}
@end
