//
//  NUMainBranchAliaser.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/07/06.
//
//

#import "NUAliaser.h"

@class NUPages, NUBell, NUMainBranchNursery, NUObjectTable, NUReversedObjectTable;

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

@interface NUMainBranchAliaser (Decoding)

- (id)decodeObjectForBell:(NUBell *)aBell;

@end

@interface NUMainBranchAliaser (ObjectSpace)

- (NUUInt64)sizeOfObject:(id)anObject;
- (NUUInt64)sizeOfObjectForBellBall:(NUBellBall)aBellBall;

- (NUUInt64)objectLocationForOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade gradeInto:(NUUInt64 *)aFoundGrade;

@end
