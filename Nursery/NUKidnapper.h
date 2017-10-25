//
//  NUKidnapper.h
//  Nursery
//
//  Created by P,T,A on 11/08/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>
#import "NUThreadedChildminder.h"

extern const NUUInt8 NUKidnapperNonePhase;
extern const NUUInt8 NUKidnapperStalkPhase;
extern const NUUInt8 NUKidnapperKidnapPhase;

@class NUIndexArray, NUMainBranchNursery, NUPeephole;

@interface NUKidnapper : NUThreadedChildminder
{
	NUIndexArray *grayOOPs;
	BOOL shouldLoadGrayOOPs;
	NUUInt8 currentPhase;
    NUUInt64 grade;
	NUPeephole *peephole;
}

+ (id)kidnapperWithPlayLot:(NUPlayLot *)aPlayLot;

- (id)initWithPlayLot:(NUPlayLot *)aPlayLot;

- (void)objectDidEncode:(NUUInt64)anOOP;

- (void)save;
- (void)load;

- (NUMainBranchNursery *)nursery;

- (NUUInt64)grade;

@end

@interface NUKidnapper (Private)

- (void)stalkObjects;
- (void)stalkObjectsUntilStop;
- (void)kidnapObjects;
- (void)pushRootOOP;
- (void)loadGrayOOPs;
- (void)pushOOPAsGrayIfWhite:(NUUInt64)anOOP;
- (void)pushOOPAsGrayIfBlack:(NUUInt64)anOOP;
- (NUUInt64)popGrayOOP;
- (void)setGrade:(NUUInt64)aGrade;

@end
