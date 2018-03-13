//
//  NUMainBranchNurseryAssociationProtocol.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/01/11.
//
//

#import <Nursery/NUTypes.h>

@protocol NUMainBranchNurseryAssociation <NSObject>

//- (NUUInt64)openSandboxForNurseryWithName:(bycopy NSString *)aName;
//- (void)closeSandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;
//
//- (NUUInt64)rootOOPForNurseryWithName:(bycopy NSString *)aName sandboxWithID:(NUUInt64)anID;
//
//- (NUUInt64)latestGradeForNurseryWithName:(bycopy NSString *)aName;
//- (NUUInt64)olderRetainedGradeForNurseryWithName:(bycopy NSString *)aName;
//- (NUUInt64)retainLatestGradeBySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;
//- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;
//- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;
//- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName;
//
//- (bycopy NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade sandboxWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils inNurseryWithName:(bycopy NSString *)aName;
//- (NUFarmOutStatus)farmOutPupils:(bycopy NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP sandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName fixedOOPs:(bycopy NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade;

- (void)openSandboxForNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 aBranchSandboxID))aHandler;
- (void)closeSandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName;

- (void)rootOOPForNurseryWithName:(NSString *)aName sandboxWithID:(NUUInt64)anID completionHandler:(void (^)(NUUInt64))aHandler;

- (void)latestGradeForNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 aLatestGrade))aHandler;
- (void)olderRetainedGradeForNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 anOlderRetaindGrade))aHandler;
- (void)retainLatestGradeBySandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 aLatestGrade))aHandler;
- (void)retainGradeIfValid:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 aGrade))aHandler;
- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName;
- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName;

- (void)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade sandboxWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils inNurseryWithName:(NSString *)aName completionHandler:(void (^)(NSData *aPupilNotesData))aHandler;
- (void)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP sandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName  completionHandler:(void (^)(NUFarmOutStatus aFarmOutStatus, NSData *aFixedOOPs, NUUInt64 aLatestGrade))aHandler;

@end
