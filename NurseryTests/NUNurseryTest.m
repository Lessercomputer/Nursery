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
#import "SelfReferenceObject.h"

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
}

- (void)testSaveEmptyNUNursery
{
	NUMainBranchNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSLog(@"retainCount of %@ is %@", aNursery, @([aNursery retainCount]));
    NUSandbox *aSandbox = [aNursery makeSandbox];
    NSLog(@"retainCount of %@ is %@", aNursery, @([aNursery retainCount]));
    NSLog(@"retainCount of %@ is %@", aSandbox, @([aSandbox retainCount]));
	XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
}

- (void)testDoubleOpenNUNursery
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [NUSandbox sandboxWithNursery:aNursery];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUNursery *aNursery2 = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox2 = [NUSandbox sandboxWithNursery:aNursery2];
    [aSandbox2 root];
    XCTAssertEqual([aNursery2 openStatus], NUNurseryOpenStatusClose);
}

- (void)testSaveManyNSObject
{
    NSMutableArray *anObjects = [NSMutableArray array];
    NUUInt64 anObjectsCount = 1000000;
    for (NUUInt64 i = 0; i < anObjectsCount; i++) {
        [anObjects addObject:[[NSObject new] autorelease]];
    }
    
    [self measureBlock:^{
        @autoreleasepool
        {
            NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
            NUSandbox *aSandbox = [NUSandbox sandboxWithNursery:aNursery];
            [aSandbox setRoot:anObjects];
            XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        }
    }];
}

- (void)testLoadRootFromNUNursery
{
	NSString *theRootObject = @"The Root Object";
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [NUSandbox sandboxWithNursery:aNursery];
        [aSandbox setRoot:theRootObject];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        XCTAssertEqualObjects(theRootObject, [aSandbox root], @"");
    };
	
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [NUSandbox sandboxWithNursery:aNursery];
    XCTAssertEqualObjects([aSandbox root], theRootObject, @"");
}

- (void)testSaveAndLoadNumberFromNUNursery
{
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSNumber *aNumber = [NSNumber numberWithUnsignedLongLong:1];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    [aSandbox setRoot:aNumber];
	XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandbox2 = [aNursery makeSandbox];
    XCTAssertEqualObjects(aNumber, [aSandbox2 root], @"");
}

- (void)testRepeatSaveAndLoad
{
    NSMutableArray *anArray =
    [NSMutableArray arrayWithObjects:
     @"Smalltalk-72", @"Smalltalk-74", @"Smalltalk-76", @"Smalltalk-78", @"Smalltalk-80", nil];
    NSMutableArray *aLoadedArray = nil;

    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [aSandbox setRoot:anArray];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        
        [anArray addObject:@"ObjectWorks"];
        [aSandbox markChangedObject:anArray];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        
        [anArray addObject:@"VisualWorks"];
        [aSandbox markChangedObject:anArray];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        
        [anArray addObject:@"Squeak"];
        [aSandbox markChangedObject:anArray];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");

        [anArray addObject:@"Pharo"];
        [aSandbox markChangedObject:anArray];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        
        NSDate *aDate = [NSDate date];
        [anArray addObject:aDate];
        [aSandbox markChangedObject:anArray];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
	aLoadedArray = [aSandbox root];
	XCTAssertEqualObjects(anArray, aLoadedArray, @"");
    [aLoadedArray addObject:@"DolphinSmalltalk"];
}

- (void)testSaveAndLoadIndexSet
{
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
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        
        [aSandbox setRoot:anArray];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    NSArray *aLoadedArray = [aSandbox root];
    
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:0], anEmptyIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:1], aSingleRangeIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:2], aMultiRangeIndexSet, @"");
    XCTAssertEqualObjects([aLoadedArray objectAtIndex:3], aMultiRangeIndexSet2, @"");
}

- (void)testSaveAndLoadSet
{
    NSMutableSet *aMutableSet = [NSMutableSet set];
    [aMutableSet addObject:@"aString"];
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [aSandbox setRoot:aMutableSet];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    NSMutableSet *aLoadedMutableSet = [aSandbox root];
    
    XCTAssertEqualObjects(aLoadedMutableSet, aMutableSet, @"");
    [aLoadedMutableSet addObject:@"aString2"];
}

- (void)testSaveLargeObject
{
    const int aMaxCount = 1000000;
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    
    NSMutableArray *anArray = [NSMutableArray array];
    int i = 0;
    for (; i < aMaxCount; i++)
        [anArray addObject:[NSString stringWithFormat:@"%06d", i]];
    [aSandbox setRoot:anArray];
    
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
}

- (void)testSaveAndLoadLargeObject
{
    const int aMaxCount = 100000;//45000;
    NSMutableArray *anArray = [NSMutableArray array];

    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        
        int i = 0;
        for (; i < aMaxCount; i++)
            [anArray addObject:[NSString stringWithFormat:@"%06d", i]];
        [aSandbox setRoot:anArray];
        
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"[aSandbox farmOut] failed");
    }
    
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
	NSMutableArray *aUserRoot = [aSandbox root];
	
	XCTAssertFalse(anArray == aUserRoot, @"");
	XCTAssertEqualObjects(anArray, aUserRoot, @"");
}

- (void)testSaveAndLoadMutableString
{
    NSMutableString *aMutableString = [[@"string" mutableCopy] autorelease];

    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [aSandbox setRoot:aMutableString];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
	NSMutableString *aUserRoot = [aSandbox root];
	
	XCTAssertFalse(aMutableString == aUserRoot, @"");
	XCTAssertEqualObjects(aMutableString, aUserRoot, @"");
}

- (void)testSaveAndLoadAndSearchNULibrary
{
    NULibrary *aLibrary = [NULibrary library];
    
    for (NSInteger i = 0; i < 100000; i++)
    {
        NSNumber *aNumber = @(i);
        [aLibrary setObject:aNumber forKey:aNumber];
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [aSandbox setRoot:aLibrary];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"[aSandbox farmOut] failed");
    }

    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    aLibrary = [aSandbox root];
    
    NSMutableArray *aNumbers = [NSMutableArray array];

    [aLibrary enumerateKeysAndObjectsWithKeyGreaterThan:@(1000) orEqual:YES andKeyLessThan:@(4000) orEqual:YES options:0 usingBlock:^(id aKey, id anObj, BOOL *aStop) {
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
}

- (void)testRetainCount
{
    Person *aPerson = [[Person alloc] initWithFirstName:@"aFirstName" lastName:@"aLastName"];
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [aSandbox setRoot:aPerson];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    XCTAssertTrue([aPerson retainCount] == 1, @"");
    [aPerson release];
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        aPerson = [[aSandbox root] retain];
    //    NUBell *aPersonBell = [aPerson bell];
    //    NSMutableSet *anOOPSet = [aSandbox bellSet];
    //    NSLog(@"%@", aPersonBell);
    //    NSLog(@"%@", anOOPSet);
    }
    
    XCTAssertTrue([aPerson retainCount] == 1, @"");
    [aPerson release];
}

- (void)testUpgradeCharacter
{
    Person *aPerson0 = nil, *aPerson1 = nil, *aPerson2 = nil;
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        NSMutableArray *aPersons = [NSMutableArray array];

        aPerson0 = [[Person alloc] initWithFirstName:@"aFirstName0" lastName:@"aLastName0"];
        [aPersons addObject:aPerson0];
        [aSandbox setRoot:aPersons];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [Person setCharacterVersion:1];
        [[aSandbox characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
        NSMutableArray *aPersons = [aSandbox root];
        aPerson1 = [[Person alloc] initWithFirstName:@"aFirstName1" lastName:@"aLastName1"];
        [aPerson1 setMiddleName:@"aMiddleName1"];
        [aPersons addObject:aPerson1];
        [aSandbox markChangedObject:aPersons];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [Person setCharacterVersion:2];
        [[aSandbox characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
        [[aSandbox characterForName:@"NSObject#0!Person#1"] setTargetClass:[Person class]];
        NSMutableArray *aPersons = [aSandbox root];
        aPerson2 = [[Person alloc] initWithFirstName:@"aFirstName2" lastName:@"aLastName2"];
        [aPerson2 setMiddleName:@"aMiddleName2"];
        [aPerson2 setAge:11];
        [aPersons addObject:aPerson2];
        [aSandbox markChangedObject:aPersons];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [[aSandbox characterForName:@"NSObject#0!Person#0"] setTargetClass:[Person class]];
        [[aSandbox characterForName:@"NSObject#0!Person#1"] setTargetClass:[Person class]];
        [[aSandbox characterForName:@"NSObject#0!Person#2"] setTargetClass:[Person class]];
        NSMutableArray *aPersons = [aSandbox root];

        [Person setCharacterVersion:0];
        XCTAssertEqualObjects(aPersons[0], aPerson0, @"");
        [Person setCharacterVersion:1];
        XCTAssertEqualObjects(aPersons[1], aPerson1, @"");
        [Person setCharacterVersion:2];
        XCTAssertEqualObjects(aPersons[2], aPerson2, @"");
        
        [aPersons[0] setMiddleName:@"aMiddleName0"];
        [aSandbox markChangedObject:aPersons[0]];
        [aPersons[1] setMiddleName:@"aMiddleName1-2"];
        [aSandbox markChangedObject:aPersons[1]];
        [aPersons[2] setMiddleName:@"aMiddleName2-2"];
        [aSandbox markChangedObject:aPersons[2]];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        [aPerson0 autorelease];
        [aPerson1 autorelease];
        [aPerson2 autorelease];
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        NSMutableArray *aPersons = [aSandbox root];
        XCTAssertEqualObjects([aPersons[0] middleName], @"aMiddleName0", @"");
        XCTAssertEqualObjects([aPersons[1] middleName], @"aMiddleName1-2", @"");
        XCTAssertEqualObjects([aPersons[2] middleName], @"aMiddleName2-2", @"");
    }
}

- (void)testAllTypesObject
{
    AllTypesObject *anObject = [[AllTypesObject new] autorelease];
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [aSandbox setRoot:anObject];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    XCTAssertEqualObjects([aSandbox root], anObject);
}

- (void)testAllTypesObjectWithKeyedCoding
{
    [AllTypesObject setUseKeyedCoding:YES];
    
    AllTypesObject *anObject = [[AllTypesObject new] autorelease];
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUSandbox *aSandbox = [aNursery makeSandbox];
        [aSandbox setRoot:anObject];
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    XCTAssertEqualObjects([aSandbox root], anObject);
}

- (void)testMakeSandboxWithGrade
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    
    [aSandbox setRoot:@"NextStep"];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandboxWithPastGrade1 = [aNursery makeSandboxWithGrade:[aSandbox grade]];
    
    [aSandbox setRoot:@"NeXTstep"];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandboxWithPastGrade2 = [aNursery makeSandboxWithGrade:[aSandbox grade]];
    
    [aSandbox setRoot:@"NeXTSTEP"];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandboxWithPastGrade3 = [aNursery makeSandboxWithGrade:[aSandbox grade]];
    
    [aSandbox setRoot:@"NEXTSTEP"];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    NUSandbox *aSandboxWithPastGrade4 = [aNursery makeSandboxWithGrade:[aSandbox grade]];
    
    XCTAssertEqualObjects([aSandboxWithPastGrade1 root], @"NextStep");
    XCTAssertEqualObjects([aSandboxWithPastGrade2 root], @"NeXTstep");
    XCTAssertEqualObjects([aSandboxWithPastGrade3 root], @"NeXTSTEP");
    XCTAssertEqualObjects([aSandboxWithPastGrade4 root], @"NEXTSTEP");
}

- (void)testMoveUp
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    
    [aSandbox setRoot:[[@"first" mutableCopy] autorelease]];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aNursery makeSandbox];
    NUSandbox *aSandboxB = [aNursery makeSandbox];
    
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
}

@class NUNSNumber;

- (void)testMoveUpOfMutableArray
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    
    [aSandbox setRoot:[NSMutableArray array]];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aNursery makeSandbox];
    NSMutableArray *aMutableArray = [aSandboxA root];
    [aMutableArray addObject:@(1)];
    [aSandboxA markChangedObject:aMutableArray];
    XCTAssertEqual([aSandboxA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [aSandbox moveUp];
    [aSandbox moveUpObject:[aSandbox root]];
    
//    NSLog(@"[[aNursery sandbox] root]:%@, [aSandboxA root]:%@", [[aNursery sandbox] root], [aSandboxA root]);
    
    XCTAssertEqualObjects([aSandbox root], [aSandboxA root]);
}

- (void)testMoveUpOfMutableDictionary
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    
    [aSandbox setRoot:[NSMutableDictionary dictionary]];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aNursery makeSandbox];
    NSMutableDictionary *aMutableDictionary = [aSandboxA root];
    [aMutableDictionary setObject:@(1) forKey:@(1)];
    [aSandboxA markChangedObject:aMutableDictionary];
    XCTAssertEqual([aSandboxA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [aSandbox moveUp];
    [aSandbox moveUpObject:[aSandbox root]];
    
    XCTAssertEqualObjects([aSandbox root], [aSandboxA root]);
}

- (void)testMoveUpOfMutableSet
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aSandbox = [aNursery makeSandbox];
    
    [aSandbox setRoot:[NSMutableSet set]];
    XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aNursery makeSandbox];
    NSMutableSet *aMutableSet = [aSandboxA root];
    [aMutableSet addObject:@(1)];
    [aSandboxA markChangedObject:aMutableSet];
    XCTAssertEqual([aSandboxA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [aSandbox moveUp];
    [aSandbox moveUpObject:[aSandbox root]];
    
    XCTAssertEqualObjects([aSandbox root], [aSandboxA root]);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-circular-container"
- (void)testCircularReferenceOfObjectNotConformingToNUCoding
{
    NSMutableArray *anArray = [NSMutableArray new];
    
    [anArray addObject:anArray];

    [self _testCircularReferenceOf:anArray replacedBy:[NSMutableArray array] expectedRetainCountOfBell:2];
    
    [anArray removeAllObjects];
    [anArray release];
}
#pragma clang diagnostic pop

- (void)testCircularReferenceOfObjectConformingToNUCoding
{
    SelfReferenceObject *aSelfReferenceObject = [SelfReferenceObject new];
    [aSelfReferenceObject setMyself:aSelfReferenceObject];
    
    [self _testCircularReferenceOf:aSelfReferenceObject replacedBy:[[SelfReferenceObject new] autorelease] expectedRetainCountOfBell:1];
    
    [aSelfReferenceObject setMyself:nil];
//    NSLog(@"retainCount of %@ is %@", aSelfReferenceObject, @([aSelfReferenceObject retainCount]));
    [aSelfReferenceObject release];
}

- (void)_testCircularReferenceOf:(id)anObject replacedBy:(id)aNewObject expectedRetainCountOfBell:(NSInteger)anExpectedRetainCount
{
    NUNursery *aNursery = nil;
    NUSandbox *aSandbox = nil;
    NUUInt64 aRootOOP = 0;
    
    @autoreleasepool
    {
        aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        aSandbox = [aNursery makeSandbox];
        
        
        [aSandbox setRoot:anObject];
        
        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        
        aRootOOP = [[aSandbox bellForObject:[aSandbox root]] OOP];
        
        [aSandbox setRoot:aNewObject];

        XCTAssertEqual([aSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        
        [NSThread sleepForTimeInterval:5];
        NUBell *aBell = [aSandbox bellForOOP:aRootOOP];
        XCTAssertEqual([aBell retainCount], anExpectedRetainCount);
//        NSLog(@"retainCount of %@ is %@", aBell, @([aBell retainCount]));
    }
}

@end
