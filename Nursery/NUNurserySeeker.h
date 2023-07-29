//
//  NUNurserySeeker.h
//  Nursery
//
//  Created by Akifumi Takata on 11/08/17.
//

#import "NUTypes.h"
#import "NUChildminder.h"

typedef enum : NUUInt8 {
    NUSeekerNonePhase,
    NUSeekerSeekPhase,
    NUSeekerCollectPhase,
} NUSeekerPhase;


@class NUUInt64Queue, NUMainBranchNursery, NUAperture, NUBell;

@interface NUNurserySeeker : NUChildminder
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
