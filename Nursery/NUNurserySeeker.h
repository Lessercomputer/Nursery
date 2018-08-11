//
//  NUNurserySeeker.h
//  Nursery
//
//  Created by Akifumi Takata on 11/08/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUTypes.h"
#import "NUThreadedChildminder.h"

typedef enum : NUUInt8 {
    NUSeekerNonePhase,
    NUSeekerSeekPhase,
    NUSeekerCollectPhase,
} NUSeekerPhase;


@class NUUInt64Queue, NUMainBranchNursery, NUAperture;

@interface NUNurserySeeker : NUThreadedChildminder
{
	NUUInt64Queue *grayOOPs;
	BOOL shouldLoadGrayOOPs;
	NUUInt8 currentPhase;
    NUUInt64 grade;
	NUAperture *aperture;
    NUBellBall nextBellBallToCollect;
}

+ (id)seekerWithGarden:(NUGarden *)aGarden;

- (id)initWithGarden:(NUGarden *)aGarden;

- (void)objectDidEncode:(NUUInt64)anOOP;

- (void)save;
- (void)load;

- (NUMainBranchNursery *)nursery;

- (NUUInt64)grade;

@end

@interface NUNurserySeeker (Private)

- (void)preprocess;
- (void)resetAllGCMarksIfNeeded;
- (void)seekObjectsOneUnit;
- (void)collectObjectsOneUnit;
- (void)collectObjectIfNeeded:(NUBellBall)aBellBall;
- (void)pushRootOOP;
- (void)loadGrayOOPsIfNeeded;
- (void)loadGrayOOPs;
- (void)pushOOPAsGrayIfWhite:(NUUInt64)anOOP;
- (void)pushOOPAsGrayIfBlack:(NUUInt64)anOOP;
- (NUUInt64)popGrayOOP;
- (void)setGrade:(NUUInt64)aGrade;

@end
