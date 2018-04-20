//
//  NUSeeker.h
//  Nursery
//
//  Created by Akifumi Takata on 11/08/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUTypes.h"
#import "NUThreadedChildminder.h"

extern const NUUInt8 NUSeekerNonePhase;
extern const NUUInt8 NUSeekerSeekPhase;
extern const NUUInt8 NUSeekerCollectPhase;

@class NUIndexArray, NUMainBranchNursery, NUAperture;

@interface NUSeeker : NUThreadedChildminder
{
	NUIndexArray *grayOOPs;
	BOOL shouldLoadGrayOOPs;
	NUUInt8 currentPhase;
    NUUInt64 grade;
	NUAperture *aperture;
}

+ (id)seekerWithGarden:(NUGarden *)aGarden;

- (id)initWithGarden:(NUGarden *)aGarden;

- (void)objectDidEncode:(NUUInt64)anOOP;

- (void)save;
- (void)load;

- (NUMainBranchNursery *)nursery;

- (NUUInt64)grade;

@end

@interface NUSeeker (Private)

- (void)seekObjects;
- (void)seekObjectsUntilStop;
- (void)collectObjects;
- (void)pushRootOOP;
- (void)loadGrayOOPs;
- (void)pushOOPAsGrayIfWhite:(NUUInt64)anOOP;
- (void)pushOOPAsGrayIfBlack:(NUUInt64)anOOP;
- (NUUInt64)popGrayOOP;
- (void)setGrade:(NUUInt64)aGrade;

@end
