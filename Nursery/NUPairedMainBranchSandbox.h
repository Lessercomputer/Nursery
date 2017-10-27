//
//  NUPairedMainBranchSandbox.h
//  Nursery
//
//  Created by P,T,A on 2014/03/15.
//
//

#import <Nursery/Nursery.h>

@class NUPairedMainBranchAliaser;

@interface NUPairedMainBranchSandbox : NUMainBranchSandbox

- (NUPairedMainBranchAliaser *)pairedMainBranchAliaser;

@end

@interface NUPairedMainBranchSandbox (Pupil)

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade containsFellowPupils:(BOOL)aContainsFellowPupils;
- (NUFarmOutStatus)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP fixedOOPs:(NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade;

@end
