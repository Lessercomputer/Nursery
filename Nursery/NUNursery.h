//
//  NUNursery.h
//  Nursery
//
//  Created by P,T,A on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@class NUCharacter, NUBell, NUObjectWrapper, NUAliaser, NUNurseryRoot, NUSandbox;

extern NSString * const NUOOPNotFoundException;

extern NUUInt64 NUNilSandboxID;
extern NUUInt64 NUFirstSandboxID;

typedef enum : NSUInteger {
    NUNurseryOpenStatusClose,
    NUNurseryOpenStatusOpenWithoutFile,
    NUNurseryOpenStatusOpenWithFile,
} NUNurseryOpenStatus;

@interface NUNursery : NSObject
{
    NUNurseryOpenStatus openStatus;
	NUSandbox *sandbox;
}
@end

@interface NUNursery (InitializingAndRelease)

@end

@interface NUNursery (Accessing)

- (NUSandbox *)sandbox;

@end

@interface NUNursery (Grade)

- (NUUInt64)latestGrade:(NUSandbox *)sender;
- (NUUInt64)olderRetainedGrade:(NUSandbox *)sender;

- (NUUInt64)retainLatestGradeBySandbox:(NUSandbox *)sender;
- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade bySandbox:(NUSandbox *)sender;
- (void)retainGrade:(NUUInt64)aGrade bySandbox:(NUSandbox *)sender;
- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandbox:(NUSandbox *)sender;

- (NUUInt64)retainLatestGradeBySandboxWithID:(NUUInt64)anID;
- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID;
- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID;

@end

@interface NUNursery (Sandbox)

- (NUSandbox *)createSandbox;
- (NUSandbox *)createSandboxWithGrade:(NUUInt64)aGrade;

- (void)sandboxDidClose:(NUSandbox *)aSandbox;

@end

@interface NUNursery (Testing)

- (BOOL)isMainBranch;

@end

@interface NUNursery (Private)

- (void)setSandbox:(NUSandbox *)aSandbox;

- (BOOL)open;
- (void)close;

- (NUNurseryOpenStatus)openStatus;
- (void)setOpenStatus:(NUNurseryOpenStatus)aStatus;

@end
