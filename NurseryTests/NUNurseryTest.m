//
//  NUTest.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/01.
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
    NUNurseryTestFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"nursery.nursery"];
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
	[[aNursery sandbox] close];
}

- (void)testSaveEmptyNUNursery
{
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
	[[aNursery sandbox] close];
}

- (void)testDoubleOpenNUNursery
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUNursery *aNursery2 = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery2 sandbox] root];
    XCTAssertEqual([aNursery2 openStatus], NUNurseryOpenStatusClose);

    [[aNursery sandbox] close];
    [[aNursery2 sandbox] close];
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
        [[aNursery sandbox] setRoot:anObjects];
        XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
        [[aNursery sandbox] close];
    }];
}

- (void)testLoadRootFromNUNursery
{
	NSString *theRootObject = @"The Root Object";
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	[[aNursery sandbox] setRoot:theRootObject];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
	XCTAssertEqualObjects(theRootObject, [[aNursery sandbox] root], @"");
	[[aNursery sandbox] close];
	
	aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    XCTAssertEqualObjects([[aNursery sandbox] root], theRootObject, @"");
	[[aNursery sandbox] close];
}

- (void)testSaveAndLoadNumberFromNUNursery
{
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSNumber *aNumber = [NSNumber numberWithUnsignedLongLong:1];
    [[aNursery sandbox] setRoot:aNumber];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandbox2 = [aNursery createSandbox];
    XCTAssertEqualObjects(aNumber, [aSandbox2 root], @"");
    [aSandbox2 close];
	[[aNursery sandbox] close];
}

- (void)testRepeatSaveAndLoad
{
	NSMutableArray *anArray =
		[NSMutableArray arrayWithObjects:
			@"Smalltalk-72", @"Smalltalk-74", @"Smalltalk-76", @"Smalltalk-78", @"Smalltalk-80", nil];
	NSMutableArray *aLoadedArray = nil;
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	[[aNursery sandbox] setRoot:anArray];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
	
	[anArray addObject:@"ObjectWorks"];
	[[aNursery sandbox] markChangedObject:anArray];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
	
	[anArray addObject:@"VisualWorks"];
	[[aNursery sandbox] markChangedObject:anArray];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
	
	[anArray addObject:@"Squeak"];
	[[aNursery sandbox] markChangedObject:anArray];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");

	[anArray addObject:@"Pharo"];
	[[aNursery sandbox] markChangedObject:anArray];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
	
	NSDate *aDate = [NSDate date];
	[anArray addObject:aDate];
	[[aNursery sandbox] markChangedObject:anArray];
	XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
	
	[[aNursery sandbox] close];

	aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	aLoadedArray = [[aNursery sandbox] root];
	XCTAssertEqualObjects(anArray, aLoadedArray, @"");
    [aLoadedArray addObject:@"DolphinSmalltalk"];
	[[aNursery sandbox] close];
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
    
    [[aNursery sandbox] setRoot:anArray];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    [[aNursery sandbox] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSArray *aLoadedArray = [[aNursery sandbox] root];
    
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:0], anEmptyIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:1], aSingleRangeIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:2], aMultiRangeIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:3], aMultiRangeIndexSet2, @"");

    [[aNursery sandbox] close];
}

- (void)testSaveAndLoadSet
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];

    NSMutableSet *aMutableSet = [NSMutableSet set];
    [aMutableSet addObject:@"aString"];
    [[aNursery sandbox] setRoot:aMutableSet];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];

    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSMutableSet *aLoadedMutableSet = [[aNursery sandbox] root];
    
    XCTAssertEqualObjects(aLoadedMutableSet, aMutableSet, @"");
    [aLoadedMutableSet addObject:@"aString2"];
    [[aNursery sandbox] close];
}

- (void)testSaveAndLoadLargeObject
{
    const int aMaxCount = 100000;//45000;
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	
	NSMutableArray *anArray = [NSMutableArray array];
	int i = 0;
	for (; i < aMaxCount; i++)
		[anArray addObject:[NSString stringWithFormat:@"%06d", i]];
	[[aNursery sandbox] setRoot:anArray];
	
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
	
	[[aNursery sandbox] close];
	
	aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	NSMutableArray *aUserRoot = [[aNursery sandbox] root];
	
	XCTAssertFalse(anArray == aUserRoot, @"");
	XCTAssertEqualObjects(anArray, aUserRoot, @"");
	[[aNursery sandbox] close];
}

- (void)testSaveAndLoadMutableString
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSMutableString *aMutableString = [[@"string" mutableCopy] autorelease];
    [[aNursery sandbox] setRoot:aMutableString];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
    [[aNursery sandbox] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
	NSMutableString *aUserRoot = [[aNursery sandbox] root];
	
	XCTAssertFalse(aMutableString == aUserRoot, @"");
	XCTAssertEqualObjects(aMutableString, aUserRoot, @"");
	[[aNursery sandbox] close];
}

- (void)testSaveAndLoadAndSearchNULibrary
{
    NULibrary *aLibrary = [NULibrary library];
    
    for (NSInteger i = 0; i < 100000; i++)
    {
        NSNumber *aNumber = @(i);
        [aLibrary setObject:aNumber forKey:aNumber];
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery sandbox] setRoot:aLibrary];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
    [[aNursery sandbox] close];

    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    aLibrary = [[aNursery sandbox] root];
    
    NSMutableArray *aNumbers = [NSMutableArray array];

    [aLibrary enumerateKeysAndObjectsFrom:@(1000) to:@(4000) options:0 usingBlock:^(id aKey, id anObj, BOOL *aStop) {
        if ([anObj integerValue] % 2 == 0)
            [aNumbers addObject:anObj];
    }];
    
    __block NSInteger aCurrent = 0;
    
    [aNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertLessThanOrEqual(aCurrent, [obj integerValue]);
        aCurrent = [obj integerValue];
        XCTAssertTrue(aCurrent % 2 == 0);
//        NSLog(@"%@", obj);
    }];
    
    [[aNursery sandbox] close];
}

- (void)testRetainCount
{
    Person *aPerson = [[Person alloc] initWithFirstName:@"aFirstName" lastName:@"aLastName"];
    
    NSAutoreleasePool *aPool = [NSAutoreleasePool new];

    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery sandbox] setRoot:aPerson];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];
    [aPool release];
    
    XCTAssertTrue([aPerson retainCount] == 1, @"");
    [aPerson release];
    
    aPool = [NSAutoreleasePool new];
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    aPerson = [[[aNursery sandbox] root] retain];
//    NUBell *aPersonBell = [aPerson bell];
//    NSMutableSet *anOOPSet = [[aNursery sandbox] bellSet];
//    NSLog(@"%@", aPersonBell);
//    NSLog(@"%@", anOOPSet);
    [[aNursery sandbox] close];
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
    [[aNursery sandbox] setRoot:aPersons];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [Person setCharacterVersion:1];
    [[[aNursery sandbox] characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
    aPersons = [[aNursery sandbox] root];
    Person *aPerson1 = [[[Person alloc] initWithFirstName:@"aFirstName1" lastName:@"aLastName1"] autorelease];
    [aPerson1 setMiddleName:@"aMiddleName1"];
    [aPersons addObject:aPerson1];
    [[aNursery sandbox] markChangedObject:aPersons];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [Person setCharacterVersion:2];
    [[[aNursery sandbox] characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
    [[[aNursery sandbox] characterForName:@"NSObject#0!Person#1"] setTargetClass:[Person class]];
    aPersons = [[aNursery sandbox] root];
    Person *aPerson2 = [[[Person alloc] initWithFirstName:@"aFirstName2" lastName:@"aLastName2"] autorelease];
    [aPerson2 setMiddleName:@"aMiddleName2"];
    [aPerson2 setAge:11];
    [aPersons addObject:aPerson2];
    [[aNursery sandbox] markChangedObject:aPersons];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];

    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[[aNursery sandbox] characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
    [[[aNursery sandbox] characterForName:@"NSObject#0!Person#1"] setTargetClass:[Person class]];
    [[[aNursery sandbox] characterForName:@"NSObject#0!Person#2"] setTargetClass:[Person class]];
    aPersons = [[aNursery sandbox] root];

    [Person setCharacterVersion:0];
    XCTAssertEqualObjects(aPersons[0], aPerson0, @"");
    [Person setCharacterVersion:1];
    XCTAssertEqualObjects(aPersons[1], aPerson1, @"");
    [Person setCharacterVersion:2];
    XCTAssertEqualObjects(aPersons[2], aPerson2, @"");
    
    [aPersons[0] setMiddleName:@"aMiddleName0"];
    [[aNursery sandbox] markChangedObject:aPersons[0]];
    [aPersons[1] setMiddleName:@"aMiddleName1-2"];
    [[aNursery sandbox] markChangedObject:aPersons[1]];
    [aPersons[2] setMiddleName:@"aMiddleName2-2"];
    [[aNursery sandbox] markChangedObject:aPersons[2]];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    aPersons = [[aNursery sandbox] root];
    XCTAssertEqualObjects([aPersons[0] middleName], @"aMiddleName0", @"");
    XCTAssertEqualObjects([aPersons[1] middleName], @"aMiddleName1-2", @"");
    XCTAssertEqualObjects([aPersons[2] middleName], @"aMiddleName2-2", @"");
    [[aNursery sandbox] close];
    
    [aPool release];
}

- (void)testAllTypesObject
{
    AllTypesObject *anObject = [[AllTypesObject new] autorelease];
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery sandbox] setRoot:anObject];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    XCTAssertEqualObjects([[aNursery sandbox] root], anObject);
    [[aNursery sandbox] close];
}

- (void)testAllTypesObjectWithKeyedCoding
{
    [AllTypesObject setUseKeyedCoding:YES];
    
    AllTypesObject *anObject = [[AllTypesObject new] autorelease];
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    [[aNursery sandbox] setRoot:anObject];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    XCTAssertEqualObjects([[aNursery sandbox] root], anObject);
    [[aNursery sandbox] close];
}

- (void)testCreateSandboxWithGrade
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[aNursery sandbox] setRoot:@"NextStep"];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandboxWithPastGrade1 = [aNursery createSandboxWithGrade:[[aNursery sandbox] grade]];
    
    [[aNursery sandbox] setRoot:@"NeXTstep"];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandboxWithPastGrade2 = [aNursery createSandboxWithGrade:[[aNursery sandbox] grade]];
    
    [[aNursery sandbox] setRoot:@"NeXTSTEP"];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandboxWithPastGrade3 = [aNursery createSandboxWithGrade:[[aNursery sandbox] grade]];
    
    [[aNursery sandbox] setRoot:@"NEXTSTEP"];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandboxWithPastGrade4 = [aNursery createSandboxWithGrade:[[aNursery sandbox] grade]];
    
    XCTAssertEqualObjects([aSandboxWithPastGrade1 root], @"NextStep");
    XCTAssertEqualObjects([aSandboxWithPastGrade2 root], @"NeXTstep");
    XCTAssertEqualObjects([aSandboxWithPastGrade3 root], @"NeXTSTEP");
    XCTAssertEqualObjects([aSandboxWithPastGrade4 root], @"NEXTSTEP");
    
    [aSandboxWithPastGrade1 close];
    [aSandboxWithPastGrade2 close];
    [aSandboxWithPastGrade3 close];
    [aSandboxWithPastGrade4 close];
    [[aNursery sandbox] close];
}

- (void)testMoveUp
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[aNursery sandbox] setRoot:[[@"first" mutableCopy] autorelease]];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aNursery createSandbox];
    NUSandbox *aSandboxB = [aNursery createSandbox];
    
    [(NSMutableString *)[aSandboxA root] setString:@"A"];
    [aSandboxA markChangedObject:[aSandboxA root]];
    
    [(NSMutableString *)[aSandboxB root] setString:@"B"];
    [aSandboxB markChangedObject:[aSandboxB root]];
    
    XCTAssertEqual([aSandboxA farmOut], NUFarmOutStatusSucceeded, @"");
    
    XCTAssertEqual([aSandboxB farmOut], NUFarmOutStatusNurseryGradeUnmatched, @"");
    
    [aSandboxB moveUp];
    [aSandboxB moveUpObject:[aSandboxB root]];
    XCTAssertEqualObjects([aSandboxB root], @"A");
    [(NSMutableString *)[aSandboxB root] setString:@"B"];
    [aSandboxB markChangedObject:[aSandboxB root]];
    
    XCTAssertEqual([aSandboxB farmOut], NUFarmOutStatusSucceeded, @"");
    
    [aSandboxA close];
    [aSandboxB close];
    [[aNursery sandbox] close];
}

@class NUNSNumber;

- (void)testMoveUpOfMutableArray
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[aNursery sandbox] setRoot:[NSMutableArray array]];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aNursery createSandbox];
    NSMutableArray *aMutableArray = [aSandboxA root];
    [aMutableArray addObject:@(1)];
    [aSandboxA markChangedObject:aMutableArray];
    XCTAssertEqual([aSandboxA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [[aNursery sandbox] moveUp];
    [[aNursery sandbox] moveUpObject:[[aNursery sandbox] root]];
    
//    NSLog(@"[[aNursery sandbox] root]:%@, [aSandboxA root]:%@", [[aNursery sandbox] root], [aSandboxA root]);
    
    XCTAssertEqualObjects([[aNursery sandbox] root], [aSandboxA root]);
    
    [[aNursery sandbox] close];
}

- (void)testMoveUpOfMutableDictionary
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[aNursery sandbox] setRoot:[NSMutableDictionary dictionary]];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aNursery createSandbox];
    NSMutableDictionary *aMutableDictionary = [aSandboxA root];
    [aMutableDictionary setObject:@(1) forKey:@(1)];
    [aSandboxA markChangedObject:aMutableDictionary];
    XCTAssertEqual([aSandboxA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [[aNursery sandbox] moveUp];
    [[aNursery sandbox] moveUpObject:[[aNursery sandbox] root]];
    
    XCTAssertEqualObjects([[aNursery sandbox] root], [aSandboxA root]);
    [[aNursery sandbox] close];
}

- (void)testMoveUpOfMutableSet
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[aNursery sandbox] setRoot:[NSMutableSet set]];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aNursery createSandbox];
    NSMutableSet *aMutableSet = [aSandboxA root];
    [aMutableSet addObject:@(1)];
    [aSandboxA markChangedObject:aMutableSet];
    XCTAssertEqual([aSandboxA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [[aNursery sandbox] moveUp];
    [[aNursery sandbox] moveUpObject:[[aNursery sandbox] root]];
    
    XCTAssertEqualObjects([[aNursery sandbox] root], [aSandboxA root]);
    [[aNursery sandbox] close];
}

@end
