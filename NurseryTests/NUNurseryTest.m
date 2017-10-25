//
//  NUTest.m
//  Nursery
//
//  Created by P,T,A on 10/10/01.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Nursery/Nursery.h>
#import "Person.h"
#import "AllTypesObject.h"

static NSString *NUNurseryTestFilePath = nil;

@interface NUNurseryTest : XCTestCase

@end

@implementation NUNurseryTest

- (void)setUp
{
    [super setUp];
    NUNurseryTestFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"nursery.nu"];
	[[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];
}

- (void)tearDown
{
	[[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];
    [super tearDown];
}

- (void)testInitializeNUNursery
{
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	XCTAssertNotNil(aNursery, @"");
	[[aNursery playLot] close];
}

- (void)testSaveEmptyNUNursery
{
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
	[[aNursery playLot] close];
}

- (void)testDoubleOpenNUNursery
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUNursery *aNursery2 = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery2 playLot] root];
    XCTAssertEqual([aNursery2 openStatus], NUNurseryOpenStatusClose);

    [[aNursery playLot] close];
    [[aNursery2 playLot] close];
}

- (void)testSaveManyNSObject
{
    NSMutableArray *anObjects = [NSMutableArray array];
    NUUInt64 anObjectsCount = 1000000;
    for (NUUInt64 i = 0; i < anObjectsCount; i++) {
        [anObjects addObject:[[NSObject new] autorelease]];
    }
    
    [self measureBlock:^{
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        [[aNursery playLot] setRoot:anObjects];
        XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
        [[aNursery playLot] close];
    }];
}

- (void)testLoadRootFromNUNursery
{
	NSString *theRootObject = @"The Root Object";
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	[[aNursery playLot] setRoot:theRootObject];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
	XCTAssertEqualObjects(theRootObject, [[aNursery playLot] root], @"");
	[[aNursery playLot] close];
	
	aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    XCTAssertEqualObjects([[aNursery playLot] root], theRootObject, @"");
	[[aNursery playLot] close];
}

- (void)testSaveAndLoadNumberFromNUNursery
{
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSNumber *aNumber = [NSNumber numberWithUnsignedLongLong:1];
    [[aNursery playLot] setRoot:aNumber];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    NUPlayLot *aPlayLot2 = [aNursery createPlayLot];
    XCTAssertEqualObjects(aNumber, [aPlayLot2 root], @"");
    [aPlayLot2 close];
	[[aNursery playLot] close];
}

- (void)testRepeatSaveAndLoad
{
	NSMutableArray *anArray =
		[NSMutableArray arrayWithObjects:
			@"Smalltalk-72", @"Smalltalk-74", @"Smalltalk-76", @"Smalltalk-78", @"Smalltalk-80", nil];
	NSMutableArray *aLoadedArray = nil;
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	[[aNursery playLot] setRoot:anArray];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
	
	[anArray addObject:@"ObjectWorks"];
	[[aNursery playLot] markChangedObject:anArray];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
	
	[anArray addObject:@"VisualWorks"];
	[[aNursery playLot] markChangedObject:anArray];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
	
	[anArray addObject:@"Squeak"];
	[[aNursery playLot] markChangedObject:anArray];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");

	[anArray addObject:@"Pharo"];
	[[aNursery playLot] markChangedObject:anArray];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
	
	NSDate *aDate = [NSDate date];
	[anArray addObject:aDate];
	[[aNursery playLot] markChangedObject:anArray];
	XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
	
	[[aNursery playLot] close];

	aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	aLoadedArray = [[aNursery playLot] root];
	XCTAssertEqualObjects(anArray, aLoadedArray, @"");
    [aLoadedArray addObject:@"DolphinSmalltalk"];
	[[aNursery playLot] close];
}

- (void)testSaveAndLoadIndexSet
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    NSMutableArray *anArray = [NSMutableArray array];
    NSIndexSet *anEmptyIndexSet = [NSIndexSet indexSet];
    NSIndexSet *aSingleRangeIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
    NSMutableIndexSet *aMultiRangeIndexSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
    [aMultiRangeIndexSet addIndexesInRange:NSMakeRange(10, 10)];
    NSMutableIndexSet *aMultiRangeIndexSet2 = [NSMutableIndexSet indexSetWithIndex:150];
    [aMultiRangeIndexSet2 addIndex:152];
    
    [anArray addObject:anEmptyIndexSet];
    [anArray addObject:aSingleRangeIndexSet];
    [anArray addObject:aMultiRangeIndexSet];
    [anArray addObject:aMultiRangeIndexSet2];
    
    [[aNursery playLot] setRoot:anArray];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    
    [[aNursery playLot] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSArray *aLoadedArray = [[aNursery playLot] root];
    
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:0], anEmptyIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:1], aSingleRangeIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:2], aMultiRangeIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:3], aMultiRangeIndexSet2, @"");

    [[aNursery playLot] close];
}

- (void)testSaveAndLoadSet
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];

    NSMutableSet *aMutableSet = [NSMutableSet set];
    [aMutableSet addObject:@"aString"];
    [[aNursery playLot] setRoot:aMutableSet];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery playLot] close];

    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSMutableSet *aLoadedMutableSet = [[aNursery playLot] root];
    
    XCTAssertEqualObjects(aLoadedMutableSet, aMutableSet, @"");
    [aLoadedMutableSet addObject:@"aString2"];
    [[aNursery playLot] close];
}

- (void)testSaveAndLoadLargeObject
{
    const int aMaxCount = 100000;//45000;
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	
	NSMutableArray *anArray = [NSMutableArray array];
	int i = 0;
	for (; i < aMaxCount; i++)
		[anArray addObject:[NSString stringWithFormat:@"%06d", i]];
	[[aNursery playLot] setRoot:anArray];
	
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
	
	[[aNursery playLot] close];
	
	aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	NSMutableArray *aUserRoot = [[aNursery playLot] root];
	
	XCTAssertFalse(anArray == aUserRoot, @"");
	XCTAssertEqualObjects(anArray, aUserRoot, @"");
	[[aNursery playLot] close];
}

- (void)testSaveAndLoadMutableString
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSMutableString *aMutableString = [[@"string" mutableCopy] autorelease];
    [[aNursery playLot] setRoot:aMutableString];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
    [[aNursery playLot] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	NSMutableString *aUserRoot = [[aNursery playLot] root];
	
	XCTAssertFalse(aMutableString == aUserRoot, @"");
	XCTAssertEqualObjects(aMutableString, aUserRoot, @"");
	[[aNursery playLot] close];
}

- (void)testRetainCount
{
    Person *aPerson = [[Person alloc] initWithFirstName:@"aFirstName" lastName:@"aLastName"];
    
    NSAutoreleasePool *aPool = [NSAutoreleasePool new];

    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery playLot] setRoot:aPerson];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery playLot] close];
    [aPool release];
    
    XCTAssertTrue([aPerson retainCount] == 1, @"");
    [aPerson release];
    
    aPool = [NSAutoreleasePool new];
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    aPerson = [[[aNursery playLot] root] retain];
    NUBell *aPersonBell = [aPerson bell];
    NSMutableSet *anOOPSet = [[aNursery playLot] bellSet];
    NSLog(@"%@", aPersonBell);
    NSLog(@"%@", anOOPSet);
    [[aNursery playLot] close];
    [aPool release];
    
    XCTAssertTrue([aPerson retainCount] == 1, @"");
    [aPerson release];
}

- (void)testUpgradeCharacter
{
    NSAutoreleasePool *aPool = [NSAutoreleasePool new];
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSMutableArray *aPersons = [NSMutableArray array];
    Person *aPerson0 = [[[Person alloc] initWithFirstName:@"aFirstName0" lastName:@"aLastName0"] autorelease];
    
    [aPersons addObject:aPerson0];
    [[aNursery playLot] setRoot:aPersons];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    [aNursery close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [Person setCharacterVersion:1];
    [[[aNursery playLot] characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
    aPersons = [[aNursery playLot] root];
    Person *aPerson1 = [[[Person alloc] initWithFirstName:@"aFirstName1" lastName:@"aLastName1"] autorelease];
    [aPerson1 setMiddleName:@"aMiddleName1"];
    [aPersons addObject:aPerson1];
    [[aNursery playLot] markChangedObject:aPersons];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    [aNursery close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [Person setCharacterVersion:2];
    [[[aNursery playLot] characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
    [[[aNursery playLot] characterForName:@"NSObject#0!Person#1"] setTargetClass:[Person class]];
    aPersons = [[aNursery playLot] root];
    Person *aPerson2 = [[[Person alloc] initWithFirstName:@"aFirstName2" lastName:@"aLastName2"] autorelease];
    [aPerson2 setMiddleName:@"aMiddleName2"];
    [aPerson2 setAge:11];
    [aPersons addObject:aPerson2];
    [[aNursery playLot] markChangedObject:aPersons];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    [aNursery close];

    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[[aNursery playLot] characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
    [[[aNursery playLot] characterForName:@"NSObject#0!Person#1"] setTargetClass:[Person class]];
    [[[aNursery playLot] characterForName:@"NSObject#0!Person#2"] setTargetClass:[Person class]];
    aPersons = [[aNursery playLot] root];

    [Person setCharacterVersion:0];
    XCTAssertEqualObjects(aPersons[0], aPerson0, @"");
    [Person setCharacterVersion:1];
    XCTAssertEqualObjects(aPersons[1], aPerson1, @"");
    [Person setCharacterVersion:2];
    XCTAssertEqualObjects(aPersons[2], aPerson2, @"");
    
    [aPersons[0] setMiddleName:@"aMiddleName0"];
    [[aNursery playLot] markChangedObject:aPersons[0]];
    [aPersons[1] setMiddleName:@"aMiddleName1-2"];
    [[aNursery playLot] markChangedObject:aPersons[1]];
    [aPersons[2] setMiddleName:@"aMiddleName2-2"];
    [[aNursery playLot] markChangedObject:aPersons[2]];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    [aNursery close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    aPersons = [[aNursery playLot] root];
    XCTAssertEqualObjects([aPersons[0] middleName], @"aMiddleName0", @"");
    XCTAssertEqualObjects([aPersons[1] middleName], @"aMiddleName1-2", @"");
    XCTAssertEqualObjects([aPersons[2] middleName], @"aMiddleName2-2", @"");
    [aNursery close];
    
    [aPool release];
}

- (void)testAllTypesObject
{
    AllTypesObject *anObject = [[AllTypesObject new] autorelease];
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery playLot] setRoot:anObject];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    [aNursery close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    XCTAssertEqualObjects([[aNursery playLot] root], anObject);
    [aNursery close];
}

- (void)testAllTypesObjectWithKeyedCoding
{
    [AllTypesObject setUseKeyedCoding:YES];
    
    AllTypesObject *anObject = [[AllTypesObject new] autorelease];
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery playLot] setRoot:anObject];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    [aNursery close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    XCTAssertEqualObjects([[aNursery playLot] root], anObject);
    [aNursery close];
}

- (void)testCreatePlayLotWithGrade
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[aNursery playLot] setRoot:@"NextStep"];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    NUPlayLot *aPlayLotWithPastGrade1 = [aNursery createPlayLotWithGrade:[[aNursery playLot] grade]];
    
    [[aNursery playLot] setRoot:@"NeXTstep"];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    NUPlayLot *aPlayLotWithPastGrade2 = [aNursery createPlayLotWithGrade:[[aNursery playLot] grade]];
    
    [[aNursery playLot] setRoot:@"NeXTSTEP"];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    NUPlayLot *aPlayLotWithPastGrade3 = [aNursery createPlayLotWithGrade:[[aNursery playLot] grade]];
    
    [[aNursery playLot] setRoot:@"NEXTSTEP"];
    XCTAssertEqual([[aNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    NUPlayLot *aPlayLotWithPastGrade4 = [aNursery createPlayLotWithGrade:[[aNursery playLot] grade]];
    
    XCTAssertEqualObjects([aPlayLotWithPastGrade1 root], @"NextStep");
    XCTAssertEqualObjects([aPlayLotWithPastGrade2 root], @"NeXTstep");
    XCTAssertEqualObjects([aPlayLotWithPastGrade3 root], @"NeXTSTEP");
    XCTAssertEqualObjects([aPlayLotWithPastGrade4 root], @"NEXTSTEP");
    
    [aPlayLotWithPastGrade1 close];
    [aPlayLotWithPastGrade2 close];
    [aPlayLotWithPastGrade3 close];
    [aPlayLotWithPastGrade4 close];
    [[aNursery playLot] close];
    [aNursery close];
}
@end
