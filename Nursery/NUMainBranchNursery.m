//
//  NUMainBranchNursery.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUMainBranchNursery.h"
#import "NUSandbox.h"
#import "NUNurseryRoot.h"
#import "NUObjectTable.h"
#import "NUReversedObjectTable.h"
#import "NUSpaces.h"
#import "NUPages.h"
#import "NUPage.h"
#import "NURegion.h"
#import "NUSeeker.h"
#import "NUParader.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBellBall.h"
#import "NUPairedMainBranchSandbox.h"

const NUUInt64 NURootObjectOOPOffset = 13;
const NUUInt64 NUNurseryCurrentGradeOffset = 93;

@implementation NUMainBranchNursery

@end

@implementation NUMainBranchNursery (InitializingAndRelease)

+ (id)nurseryWithContentsOfFile:(NSString *)aFilePath
{
	return [[[self alloc] initWithContentsOfFile:aFilePath] autorelease];
}

- (id)initWithContentsOfFile:(NSString *)aFilePath
{
	if (self = [super init])
    {
//        if (!aFilePath)
//        {
//            [self release];
//            return nil;
//        }
        
        nextSandboxID = NUFirstSandboxID;
        lock = [NSRecursiveLock new];
        [self setFilePath:aFilePath];
        [self setSpaces:[NUSpaces spacesWithNursery:self]];
        [self setObjectTable:[[[NUObjectTable alloc] initWithRootLocation:0 on:[self spaces]] autorelease]];
        [self setReversedObjectTable:[[[NUReversedObjectTable alloc] initWithRootLocation:0 on:[self spaces]] autorelease]];
        [[self spaces] prepareNodeOOPToTreeDictionary];
        retainedGrades = [NSMutableDictionary new];
        [self setSeeker:[NUSeeker seekerWithSandbox:[NUSandbox sandboxWithNursery:self usesGradeSeeker:NO]]];
        [self setParader:[NUParader paraderWithSandbox:[NUSandbox sandboxWithNursery:self usesGradeSeeker:NO]]];
        [[self seeker] prepare];
        [[self parader] prepare];
        [self setSandbox:[NUSandbox sandboxWithNursery:self usesGradeSeeker:YES]];
    }
    
	return self;
}

- (void)dealloc
{
	[self setObjectTable:nil];
    [self setReversedObjectTable:nil];
	[self setSpaces:nil];
	[self setFilePath:nil];
	[self setSeeker:nil];
    [self setParader:nil];
    [retainedGrades release];
    [lock release];

	[super dealloc];
}

@end

@implementation NUMainBranchNursery (Accessing)

- (NSString *)filePath
{
	return filePath;
}

- (NSFileHandle *)fileHandle
{
	return [[[self spaces] pages] fileHandle];
}

- (NUPages *)pages
{
	return [[self spaces] pages];
}

- (NUSpaces *)spaces
{
	return spaces;
}

- (NUObjectTable *)objectTable
{
	return objectTable;
}

- (NUReversedObjectTable *)reversedObjectTable
{
    return reversedObjectTable;
}

- (NUUInt64)rootOOP
{
    if ([self grade] == NUNilGrade) return NUNilOOP;
    
    NUUInt64 aRootRawOOP = [[self pages] readUInt64At:NURootObjectOOPOffset of:0];
    return aRootRawOOP;
}

- (NUUInt64)grade
{
    return grade;
}

- (NSMutableDictionary *)retainedGrades
{
    return retainedGrades;
}

- (NUSeeker *)seeker
{
	return seeker;
}

- (NUParader *)parader
{
    return parader;
}

- (BOOL)backups
{
    return backups;
}

- (void)setBackups:(BOOL)aBackupFlag
{
    backups = aBackupFlag;
}

@end

@implementation NUMainBranchNursery (Sandbox)

- (NUUInt64)newSandboxID
{
    NUUInt64 aNewSandboxID;
    
    [lock lock];
    
    aNewSandboxID = nextSandboxID;
    nextSandboxID++;
    
    [lock unlock];
    
    return aNewSandboxID;
}

- (void)releaseSandboxID:(NUInt64)anID
{
    
}

@end

@implementation NUMainBranchNursery (Grade)

- (NUUInt64)latestGrade:(NUSandbox *)sender
{
    [lock lock];
    
    NUUInt64 aGrade = [self grade];
    
    [lock unlock];
    
    return aGrade;
}

- (NUUInt64)olderRetainedGrade:(NUSandbox *)sender
{
    [lock lock];
    
    __block NUUInt64 aGrade = NUNotFoundGrade;
    
    [[self retainedGrades] enumerateKeysAndObjectsUsingBlock:^(NSNumber *aGradeNumber, NSMutableIndexSet *aSandboxIDs, BOOL *aStop) {
        NUUInt64 aRetainedGradeNumber = [aGradeNumber unsignedLongLongValue];
        if (aRetainedGradeNumber < aGrade) aGrade = aRetainedGradeNumber;
    }];
    
    if (aGrade == NUNotFoundGrade) aGrade = NUNilGrade;
    
    [lock unlock];
    
    return aGrade;
}

- (NUUInt64)retainLatestGradeBySandboxWithID:(NUUInt64)anID
{
    [lock lock];
    
    NUUInt64 aGrade = [self grade];
    [self retainGrade:aGrade bySandboxWithID:anID];
    
    [lock unlock];
    
    return aGrade;
}

- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID
{
    [lock lock];
    
    NSNumber *aGradeNumber = @(aGrade);
    NSMutableIndexSet *aSandboxIDs = [[self retainedGrades] objectForKey:aGradeNumber];
    
    if (!aSandboxIDs)
    {
        aSandboxIDs = [NSMutableIndexSet indexSet];
        [[self retainedGrades] setObject:aSandboxIDs forKey:aGradeNumber];
    }
    
    [aSandboxIDs addIndex:anID];
    
    [lock unlock];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID
{
    [lock lock];
    
    NSMutableIndexSet *aRetainedGrades = [NSMutableIndexSet indexSet];
    
    [[self retainedGrades] enumerateKeysAndObjectsUsingBlock:^(NSNumber *aRetainedGradeNumber, NSMutableIndexSet *aSandboxIDs, BOOL *stop) {
        NUUInt64 aRetainedGrade = [aRetainedGradeNumber unsignedLongLongValue];
        if (aRetainedGrade < aGrade)
            [aRetainedGrades addIndex:aRetainedGrade];
    }];
    
    [aRetainedGrades enumerateIndexesUsingBlock:^(NSUInteger aRetainedGrade, BOOL *stop) {
        NSNumber *aGradeNumber = @(aRetainedGrade);
        NSMutableIndexSet *aSandboxIDs = [[self retainedGrades] objectForKey:aGradeNumber];
        
        if (aSandboxIDs)
        {
            [aSandboxIDs removeIndex:anID];
            
            if (![aSandboxIDs count])
                [[self retainedGrades] removeObjectForKey:aGradeNumber];
        }
    }];
    
    [lock unlock];
}

@end

@implementation NUMainBranchNursery (Testing)

- (BOOL)isOpen
{
    NUNurseryOpenStatus aStatus = [self openStatus];
	return aStatus == NUNurseryOpenStatusOpenWithFile || aStatus == NUNurseryOpenStatusOpenWithoutFile;
}

@end

@implementation NUMainBranchNursery (Private)

- (void)setFilePath:(NSString *)aFilePath
{
    [filePath autorelease];
	filePath = [aFilePath copy];
}

- (void)setSpaces:(NUSpaces *)aSpaces
{
	[spaces autorelease];
	spaces = [aSpaces retain];
}

- (void)setObjectTable:(NUObjectTable *)anObjectTable
{
	[objectTable autorelease];
	objectTable = [anObjectTable retain];
}

- (void)setReversedObjectTable:(NUReversedObjectTable *)aReversedObjectTable
{
    [reversedObjectTable autorelease];
    reversedObjectTable = [aReversedObjectTable retain];
}

- (void)setSeeker:(NUSeeker *)aSeeker
{
	[seeker autorelease];
	seeker = [aSeeker retain];
}

- (void)setParader:(NUParader *)aParader
{
    [parader autorelease];
    parader = [aParader retain];
}

- (void)setGrade:(NUUInt64)aGrade
{
    grade = aGrade;
}

- (void)setRetainedGrades:(NSMutableDictionary *)aGrades
{
    [retainedGrades autorelease];
    retainedGrades = [aGrades retain];
}

- (NUPairedMainBranchSandbox *)createPairdSandbox
{
    NUPairedMainBranchSandbox *aSandbox = [NUPairedMainBranchSandbox sandboxWithNursery:self usesGradeSeeker:NO];
    return aSandbox;
}

- (NUSandbox *)sandboxForSeeker
{
    return [[self seeker] sandbox];
}

- (NUSandbox *)sandboxForParader
{
    return [[self parader] sandbox];
}

- (NUUInt64)gradeForSeeker
{
    @try
    {
        [self lockForChange];
        
        NUUInt64 aGrade = [self olderRetainedGrade:[self sandboxForSeeker]];
        if (aGrade == NUNotFoundGrade) aGrade = [self grade];
        return aGrade;
    }
    @finally
    {
        [self unlockForChange];
    }
}

- (NUUInt64)gradeForParader
{
    @try
    {
        [self lockForChange];
        
        NUUInt64 aGrade = [self grade];
        return aGrade;
    }
    @finally
    {
        [self unlockForChange];
    }
}

- (void)lockForFarmOut
{
#ifdef DEBUG
    NSLog(@"%@: will stop seeker", self);
#endif
    
    [[self seeker] stop];
    [[self parader] stop];
    
#ifdef DEBUG
    NSLog(@"%@: did stop seeker", self);
#endif
    
    [self lockForChange];
}

- (void)unlockForFarmOut
{
    [self unlockForChange];
    
#ifdef DEBUG
    NSLog(@"%@: will start seeker", self);
#endif
    
    [[self seeker] startWithoutWait];
    [[self parader] startWithoutWait];
    
#ifdef DEBUG
    NSLog(@"%@: did start seeker", self);
#endif
}

- (void)lockForChange
{
    [lock lock];
}

- (void)unlockForChange
{
    [lock unlock];
}

- (void)lockForRead
{
    [lock lock];
}

- (void)unlockForRead
{
    [lock unlock];
}

- (BOOL)save
{
    if (![self open]) return NO;
    
	BOOL aSaved = NO;
		
    if ([self backups]) [self backup];
    
	aSaved = [self saveChanges];
    
	return aSaved;
}

- (void)backup
{
    if (![[self pages] savedNextPageLocation]) return;
    
    int aSubnumber = 0;
    NSString *aBackupFilePathWithoutExtension = [[self filePath] stringByDeletingPathExtension];
    NSString *anExtension = [[self filePath] pathExtension];
    NSString *aBackupFilePath;
    
    do {
        aSubnumber++;
        aBackupFilePath = [aBackupFilePathWithoutExtension stringByAppendingFormat:@"~%d.%@", aSubnumber, anExtension, nil];
    }
    while ([[NSFileManager defaultManager] fileExistsAtPath:aBackupFilePath]);
    
    [[NSFileManager defaultManager] copyItemAtPath:[self filePath] toPath:aBackupFilePath error:nil];
}

- (void)close
{
    if (![self isOpen]) return;
    
	[[self seeker] terminate];
    [[self parader] terminate];
    [[self fileHandle] closeFile];
    
    [super close];
}

- (BOOL)open
{
    BOOL shouldStartChildminders = NO;
    
    @try
    {
        [lock lock];

        switch ([self openStatus])
        {
            case NUNurseryOpenStatusClose:
                [self createFileAndOpenIfNeeded];
                if ([self isOpen] && [self grade] != NUNilGrade)
                    shouldStartChildminders = YES;
                break;
            case NUNurseryOpenStatusOpenWithoutFile:
                [self createFileAndOpenIfNeeded];
//                [self saveChanges];
                break;
            case NUNurseryOpenStatusOpenWithFile:
                break;
        }
    }
    @finally
    {
        [lock unlock];
    }
    
    if (shouldStartChildminders)
    {
        [[self seeker] start];
        [[self parader] start];
    }
    
    return [self isOpen];
}

- (BOOL)saveChanges
{
    if (![self isOpen]) return NO;
    
    @try
    {
        [[self seeker] stop];
        [[self parader] stop];
        
        [self lockForChange];
        
#ifdef DEBUG
        [self validateObjectTableAndReversedObjectTable];
#endif
        
        [self saveGrade];
        [[self objectTable] save];
        [[self reversedObjectTable] save];
        [[self seeker] save];
        [[self parader] save];
        [[self spaces] save];
        
#ifdef DEBUG
        [[self spaces] validateAllNodeLocations];
        [[self objectTable] validateAllNodeLocations];
        [[self reversedObjectTable] validateAllNodeLocations];
        [self validateObjectTableAndReversedObjectTable];
#endif
    }
    @finally
    {
        [self unlockForChange];
        
        [[self seeker] start];
        [[self parader] start];
    }
    
	return YES;
}

- (void)saveRootOOP:(NUUInt64)aRootOOP
{
	[[self pages] writeUInt64:aRootOOP at:NURootObjectOOPOffset of:0];
}

- (void)saveGrade
{
    [[self pages] writeUInt64:[self grade] at:NUNurseryCurrentGradeOffset];
}

- (void)loadGrade
{
    [self setGrade:[[self pages] readUInt64At:NUNurseryCurrentGradeOffset]];
}

- (NUUInt64)newGrade
{
    [lock lock];
    NUUInt64 aNewGrade = ++grade;
    [lock unlock];
    return aNewGrade;
}

- (BOOL)createFileAndOpenIfNeeded
{
    if (![self filePath])
        [self setOpenStatus:NUNurseryOpenStatusOpenWithoutFile];
    else if (![[NSFileManager defaultManager] fileExistsAtPath:[self filePath]])
        [self createFileAndOpen];
    else if ([self openFileHandle] && [self verifyFile])
        [self setOpenStatus:NUNurseryOpenStatusOpenWithFile];
    
    return [self isOpen];
}

- (BOOL)createFileAndOpen
{
	if (![[NSFileManager defaultManager] createFileAtPath:[self filePath] contents:nil attributes:nil]) return NO;
	if (![self openFileHandle]) return NO;
	
	[self initializeFileHeader];
	[self setOpenStatus:NUNurseryOpenStatusOpenWithFile];
	return [self isOpen];
}

- (BOOL)createFileAndInitialize
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) return NO;
	if (![[NSFileManager defaultManager] createFileAtPath:[self filePath] contents:nil attributes:nil]) return NO;
	if (![self openFileHandle]) return NO;
	if (![self writeFileHeader]) return NO;
    
	[self loadFileHeader];
	[self setOpenStatus:NUNurseryOpenStatusOpenWithFile];
	return [self isOpen];
}

- (BOOL)openFileHandle
{
    NSFileHandle *aFileHandle = nil;
    int fileDescriptor = open([[self filePath] fileSystemRepresentation], O_RDWR + O_EXLOCK + O_NONBLOCK);
    
    if (fileDescriptor != -1)
        aFileHandle = [[[NSFileHandle alloc] initWithFileDescriptor:fileDescriptor closeOnDealloc:YES] autorelease];
    
	[[self spaces] setFileHandle:aFileHandle];
	return [self fileHandle] ? YES : NO;
}

- (BOOL)verifyFile
{
	if (![self verifyFileHeader]) return NO;
    if (![self applyLogIfNeeded]) return NO;
    
	[self loadFileHeader];
    
#ifdef DEBUG
    [[self spaces] validateAllNodeLocations];
    [[self objectTable] validateAllNodeLocations];
    [[self reversedObjectTable] validateAllNodeLocations];
    [self validateObjectTableAndReversedObjectTable];
#endif

	return YES;
}

- (BOOL)writeFileHeader
{
	[self initializeFileHeader];
    [self saveGrade];
	[objectTable save];
	[spaces save];
	
	return YES;
}

- (void)initializeFileHeader
{
	NUUInt8 *aNurseryFileSignature = (NUUInt8 *)"nu\n";
	NUUInt8 aMajorVersion = 0, aMinorVersion = 1;
	
	[[self pages] appendPagesBy:1];
	[[self pages] write:aNurseryFileSignature length:3 at:0 of:0];
	[[self pages] write:&aMajorVersion length:sizeof(NUUInt8) at:3 of:0];
	[[self pages] write:&aMinorVersion length:sizeof(NUUInt8) at:4 of:0];
}

- (BOOL)verifyFileHeader
{
	NUUInt8 aNurseryFileSignature[3];
	NUUInt8 aMajorVersion, aMinorVersion;
	
	[[self pages] setNextPageLocation:[[self pages] pageSize]];
	[[self pages] setFileSize:[[[NSFileManager defaultManager] attributesOfItemAtPath:[self filePath] error:nil] fileSize]];
    
	[[self pages] read:aNurseryFileSignature length:3 at:0 of:0];
	[[self pages] read:&aMajorVersion length:1 at:3 of:0];
	[[self pages] read:&aMinorVersion length:1 at:4 of:0];
	
	if (memcmp(aNurseryFileSignature, "nu\n", 3) != 0) return NO;
	if (aMajorVersion != 0 || aMinorVersion != 1) return NO;
	
	return YES;
}

- (BOOL)applyLogIfNeeded
{
    return [[self pages] applyLogIfNeeded];
}

- (void)loadFileHeader
{
    [self loadGrade];
	[[self spaces] load];
	[[self objectTable] load];
    [[self reversedObjectTable] load];
	[[self seeker] load];
    [[self parader] load];
}

- (void)validateObjectTableAndReversedObjectTable
{
    NUUInt64 aBellBallCount = 0;
    
    for (NUBellBall aBellBall = [[self objectTable] firstBellBall]; !NUBellBallEquals(aBellBall, NUNotFoundBellBall); aBellBall = [[self objectTable] bellBallGreaterThanBellBall:aBellBall])
    {
        NUUInt64 anObjectLocation = [[self objectTable] objectLocationFor:aBellBall];
                
        if (anObjectLocation == NUNotFound64 || !anObjectLocation)
            [[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
        
        NUBellBall aBellBall2 = [[self reversedObjectTable] bellBallForObjectLocation:anObjectLocation];
        
        if (!NUBellBallEquals(aBellBall, aBellBall2))
            [[NSException exceptionWithName:NUOOPNotFoundException reason:NUOOPNotFoundException userInfo:nil] raise];
        
        aBellBallCount++;
    }
}

@end
