//
//  NUMainBranchAliaser.h
//  Nursery
//
//  Created by P,T,A on 2013/07/06.
//
//

#import <Nursery/Nursery.h>
#import "NUAliaser.h"

@class NUBell;

@interface NUMainBranchAliaser : NUAliaser
{
    NUUInt64 gradeForSave;
}
@end

@interface NUMainBranchAliaser (Accessing)

- (NUMainBranchNursery *)nursery;
- (NUPages *)pages;
- (NUObjectTable *)objectTable;
- (NUReversedObjectTable *)reversedObjectTable;
- (void)setGradeForSave:(NUUInt64)aGrade;

@end

@interface NUMainBranchAliaser (Contexts)

- (void)pushContextWithObjectLocation:(NUUInt64)anObjectLocation;
- (NUUInt64)currentObjectLocation;

@end

@interface NUMainBranchAliaser (ObjectSpace)

- (NUUInt64)ensureObjectSpaceFor:(NUBell *)aBell;
- (NUUInt64)allocateObjectSpaceFor:(NUBell *)aBell;
- (NUUInt64)reallocateObjectSpaceFor:(NUBell *)aBell oldSpace:(NURegion)anOldRegion withNewSize:(NUUInt64)aNewSize;
- (NUUInt64)previousSizeOfObject:(id)anObject;
- (NUUInt64)previousSizeOfObjectForBellBall:(NUBellBall)aBellBall;

- (NUUInt64)objectLocationForOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade gradeInto:(NUUInt64 *)aFoundGrade;

@end

@interface NUMainBranchAliaser (QueryingObjectLocation)

- (NUUInt64)locationForObject:(id)anObject;
- (NUUInt64)locationForOOP:(NUBell *)aBell;

@end

