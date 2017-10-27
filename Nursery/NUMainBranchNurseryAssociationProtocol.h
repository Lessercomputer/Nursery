//
//  NUMainBranchNurseryAssociationProtocol.h
//  Nursery
//
//  Created by P,T,A on 2014/01/11.
//
//

#import <Nursery/NUTypes.h>

@protocol NUMainBranchNurseryAssociation <NSObject>

- (NUUInt64)openSandboxForNurseryWithName:(bycopy NSString *)aName;
- (void)closeSandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;

- (NUUInt64)rootOOPForNurseryWithName:(bycopy NSString *)aName sandboxWithID:(NUUInt64)anID;

- (NUUInt64)latestGradeForNurseryWithName:(bycopy NSString *)aName;
- (NUUInt64)olderRetainedGradeForNurseryWithName:(bycopy NSString *)aName;
- (NUUInt64)retainLatestGradeBySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;
- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;
- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;
- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;

- (bycopy NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade sandboxWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils inNurseryWithName:(bycopy NSString *)aName;
- (NUFarmOutStatus)farmOutPupils:(bycopy NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP sandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName fixedOOPs:(bycopy NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade;

@end
