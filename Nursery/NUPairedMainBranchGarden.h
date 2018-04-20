//
//  NUPairedMainBranchGarden.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/15.
//
//

#import "NUMainBranchGarden.h"

@class NUPairedMainBranchAliaser;

@interface NUPairedMainBranchGarden : NUMainBranchGarden

- (NUPairedMainBranchAliaser *)pairedMainBranchAliaser;

@end

@interface NUPairedMainBranchGarden (Pupil)

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade containsFellowPupils:(BOOL)aContainsFellowPupils;
- (NUFarmOutStatus)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP fixedOOPs:(NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade;

@end
