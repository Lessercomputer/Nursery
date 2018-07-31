//
//  NUMainBranchNursery.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#include <string.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSIndexSet.h>
#import <Foundation/NSString.h>
#import <Foundation/NSPathUtilities.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSFileHandle.h>

#import "NUNursery+Project.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUGarden.h"
#import "NUNurseryRoot.h"
#import "NUObjectTable.h"
#import "NUReversedObjectTable.h"
#import "NUSpaces.h"
#import "NUPages.h"
#import "NUPage.h"
#import "NURegion.h"
#import "NUNurserySeeker.h"
#import "NUNurseryParader.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBellBall.h"
#import "NUPairedMainBranchGarden.h"

const NUUInt64 NURootObjectOOPOffset = 13;
const NUUInt64 NUNurseryCurrentGradeOffset = 93;

@implementation NUMainBranchNursery

@end

@implementation NUMainBranchNursery (InitializingAndRelease)

+ (instancetype)nursery
{
    return [self nurseryWithContentsOfFile:nil];
}

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
        
        nextGardenID = NUFirstGardenID;
        lock = [NSRecursiveLock new];
        [self setFilePath:aFilePath];
        [self setSpaces:[NUSpaces spacesWithNursery:self]];
        [self setObjectTable:[[[NUObjectTable alloc] initWithRootLocation:0 on:[self spaces]] autorelease]];
        [self setReversedObjectTable:[[[NUReversedObjectTable alloc] initWithRootLocation:0 on:[self spaces]] autorelease]];
        [[self spaces] prepareNodeOOPToTreeDictionary];
        retainedGrades = [NSMutableDictionary new];
        [self setSeeker:[NUNurserySeeker seekerWithGarden:[[[self class] gardenClass] gardenWithNursery:self usesGardenSeeker:NO retainNursery:NO]]];
        [self setParader:[NUNurseryParader paraderWithGarden:[[[self class] gardenClass] gardenWithNursery:self usesGardenSeeker:NO retainNursery:NO]]];
        [[self seeker] prepare];
        [[self parader] prepare];
    }
    
	return self;
}

+ (Class)gardenClass
{
    return [NUMainBranchGarden class];
}

- (void)dealloc
{
    [self close];
    
	[self setObjectTable:nil];
    [self setReversedObjectTable:nil];
	[self setSpaces:nil];
	[self setFilePath:nil];
	[self setSeeker:nil];
    [self setParader:nil];
    [retainedGrades release];
    retainedGrades = nil;
    [lock release];
    lock = nil;

	[super dealloc];
}

@end

@implementation NUMainBranchNursery (Accessing)

- (NSString *)filePath
{
	return filePath;
}

- (void)setFilePath:(NSString *)aFilePath
{
    [filePath autorelease];
    filePath = [aFilePath copy];
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

- (NUNurserySeeker *)seeker
{
	return seeker;
}

- (NUNurseryParader *)parader
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

@implementation NUMainBranchNursery (Garden)

- (NUUInt64)newGardenID
{
    NUUInt64 aNewGardenID;
    
    [lock lock];
    
    aNewGardenID = nextGardenID;
    nextGardenID++;
    
    [lock unlock];
    
    return aNewGardenID;
}

- (void)releaseGardenID:(NUInt64)anID
{
    
}

@end

@implementation NUMainBranchNursery (Grade)

- (NUUInt64)latestGrade:(NUGarden *)sender
{
    [lock lock];
    
    NUUInt64 aGrade = [self grade];
    
    [lock unlock];
    
    return aGrade;
}

- (NUUInt64)olderRetainedGrade:(NUGarden *)sender
{
    [lock lock];
    
    __block NUUInt64 aGrade = NUNotFoundGrade;
    
    [[self retainedGrades] enumerateKeysAndObjectsUsingBlock:^(NSNumber *aGradeNumber, NSMutableIndexSet *aGardenIDs, BOOL *aStop) {
        NUUInt64 aRetainedGradeNumber = [aGradeNumber unsignedLongLongValue];
        if (aRetainedGradeNumber < aGrade) aGrade = aRetainedGradeNumber;
    }];
    
    if (aGrade == NUNotFoundGrade) aGrade = NUNilGrade;
    
    [lock unlock];
    
    return aGrade;
}

- (NUUInt64)retainLatestGradeByGardenWithID:(NUUInt64)anID
{
    [lock lock];
    
    NUUInt64 aGrade = [self grade];
    [self retainGrade:aGrade byGardenWithID:anID];
    
    [lock unlock];
    
    return aGrade;
}

- (void)retainGrade:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID
{
    [lock lock];
    
    NSNumber *aGradeNumber = @(aGrade);
    NSMutableIndexSet *aGardenIDs = [[self retainedGrades] objectForKey:aGradeNumber];
    
    if (!aGardenIDs)
    {
        aGardenIDs = [NSMutableIndexSet indexSet];
        [[self retainedGrades] setObject:aGardenIDs forKey:aGradeNumber];
    }
    
    [aGardenIDs addIndex:(NSUInteger)anID];
    
    [lock unlock];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID
{
    [lock lock];
    
    NSMutableIndexSet *aRetainedGrades = [NSMutableIndexSet indexSet];
    
    [[self retainedGrades] enumerateKeysAndObjectsUsingBlock:^(NSNumber *aRetainedGradeNumber, NSMutableIndexSet *aGardenIDs, BOOL *stop) {
        NUUInt64 aRetainedGrade = [aRetainedGradeNumber unsignedLongLongValue];
        if (aRetainedGrade < aGrade)
            [aRetainedGrades addIndex:(NSUInteger)aRetainedGrade];
    }];
    
    [aRetainedGrades enumerateIndexesUsingBlock:^(NSUInteger aRetainedGrade, BOOL *stop) {
        NSNumber *aGradeNumber = @(aRetainedGrade);
        NSMutableIndexSet *aGardenIDs = [[self retainedGrades] objectForKey:aGradeNumber];
        
        if (aGardenIDs)
        {
            [aGardenIDs removeIndex:(NSUInteger)anID];
            
            if (![aGardenIDs count])
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

- (void)setSeeker:(NUNurserySeeker *)aSeeker
{
	[seeker autorelease];
	seeker = [aSeeker retain];
}

- (void)setParader:(NUNurseryParader *)aParader
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

- (NUPairedMainBranchGarden *)makePairdGarden
{
    NUPairedMainBranchGarden *aGarden = [NUPairedMainBranchGarden gardenWithNursery:self usesGardenSeeker:NO];
    return aGarden;
}

- (NUGarden *)gardenForSeeker
{
    return [[self seeker] garden];
}

- (NUGarden *)gardenForParader
{
    return [[self parader] garden];
}

- (NUUInt64)gradeForSeeker
{
    NUUInt64 aGrade;
    
    @try
    {
        [self lock];
        
        aGrade = [self olderRetainedGrade:[self gardenForSeeker]];
        if (aGrade == NUNilGrade) aGrade = [self grade];
    }
    @finally
    {
        [self unlock];
    }
    
    return aGrade;
}

- (NUUInt64)gradeForParader
{
    @try
    {
        [self lock];
        
        NUUInt64 aGrade = [self grade];
        return aGrade;
    }
    @finally
    {
        [self unlock];
    }
}

- (void)seekerDidFinishSeek:(NUNurserySeeker *)sender
{
    [[self parader] start];
}

- (void)paraderDidFinishParade:(NUNurseryParader *)sender
{
}

- (void)LockAndStopChildminders
{
#ifdef DEBUG
    NSLog(@"%@: will stop seeker", self);
#endif
    
    [[self seeker] stop];
    [[self parader] stop];
    
#ifdef DEBUG
    NSLog(@"%@: did stop seeker", self);
#endif
    
    [self lock];
}

- (void)unlockAndStartChildminders
{
    [self unlock];
    
#ifdef DEBUG
    NSLog(@"%@: will start seeker", self);
#endif
    
    [[self seeker] start];
    [[self parader] start];
    
#ifdef DEBUG
    NSLog(@"%@: did start seeker", self);
#endif
}

- (void)lock
{
    [lock lock];
}

- (void)unlock
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
    @try
    {
        [lock lock];

        switch ([self openStatus])
        {
            case NUNurseryOpenStatusClose:
                [self createFileAndOpenIfNeeded];
                break;
            case NUNurseryOpenStatusOpenWithoutFile:
                [self createFileAndOpenIfNeeded];
                break;
            case NUNurseryOpenStatusOpenWithFile:
                break;
        }
    }
    @finally
    {
        [lock unlock];
    }
   
    return [self isOpen];
}

- (BOOL)saveChanges
{
    if (![self isOpen]) return NO;
    
    @try
    {
        [self lock];
        
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
        [self unlock];
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
	NUUInt8 aMajorVersion = 0, aMinorVersion = 2;
	
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
	if (!(aMajorVersion == 0 && (aMinorVersion == 1 || aMinorVersion == 2))) return NO;
	
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
