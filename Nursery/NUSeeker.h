//
//  NUSeeker.h
//  Nursery
//
//  Created by P,T,A on 11/08/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>
#import "NUThreadedChildminder.h"

extern const NUUInt8 NUSeekerNonePhase;
extern const NUUInt8 NUSeekerSeekPhase;
extern const NUUInt8 NUSeekerKidnapPhase;

@class NUIndexArray, NUMainBranchNursery, NUAperture;

@interface NUSeeker : NUThreadedChildminder
{
	NUIndexArray *grayOOPs;
	BOOL shouldLoadGrayOOPs;
	NUUInt8 currentPhase;
    NUUInt64 grade;
	NUAperture *aperture;
}

+ (id)seekerWithSandbox:(NUSandbox *)aSandbox;

- (id)initWithSandbox:(NUSandbox *)aSandbox;

- (void)objectDidEncode:(NUUInt64)anOOP;

- (void)save;
- (void)load;

- (NUMainBranchNursery *)nursery;

- (NUUInt64)grade;

@end

@interface NUSeeker (Private)

- (void)seekObjects;
- (void)seekObjectsUntilStop;
- (void)kidnapObjects;
- (void)pushRootOOP;
- (void)loadGrayOOPs;
- (void)pushOOPAsGrayIfWhite:(NUUInt64)anOOP;
- (void)pushOOPAsGrayIfBlack:(NUUInt64)anOOP;
- (NUUInt64)popGrayOOP;
- (void)setGrade:(NUUInt64)aGrade;

@end
