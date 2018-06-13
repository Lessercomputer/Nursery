//
//  NUTest.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/01.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Nursery/Nursery.h>
#import "NUNursery+Project.h"
#import "NUGarden+Project.h"
#import "Person.h"
#import "AllTypesObject.h"
#import "SelfReferenceObject.h"
#import "NULazyMutableArray.h"
#import "CharacterTargetClassResolver.h"

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
    NUGarden *aGarden = [aNursery makeGarden];
    NSLog(@"retainCount of %@ is %@", aNursery, @([aNursery retainCount]));
    NSLog(@"retainCount of %@ is %@", aGarden, @([aGarden retainCount]));
	XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
}

- (void)testDoubleOpenNUNursery
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUNursery *aNursery2 = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden2 = [aNursery2 makeGarden];
    [aGarden2 root];
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
            NUGarden *aGarden = [aNursery makeGarden];
            [aGarden setRoot:anObjects];
            XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        }
    }];
}

- (void)testSaveManyNSNumbersUsingSameGarden
{
    [self _testSaveManyNSNumbersUsingSameGardenTimes:10 withCountPerSave:1000000];
}

- (void)testSaveFewNSNumbersManyTimesUsingSameGarden
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    NULibrary *aLibrary = [NULibrary library];
    [aGarden setRoot:aLibrary];
    
    [self measureBlock:
    ^{
        NUUInt64 aNumber = 0;
        
        for (NSUInteger i = 0; i < 1000; i++)
        {
            for (NSUInteger j = 0; j < 3; j++)
            {
                NSNumber *aNumberObject = @(aNumber++);
                [aLibrary setObject:aNumberObject forKey:aNumberObject];
            }
            
            XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded);
        }
    }];
}

- (void)testSaveManyNSNumbersUsingDifferentGardens
{
    [self _testSaveManyNSNumbersUsingDifferentGardensTimes:10 withCountPerSave:100];
}

- (void)_testSaveManyNSNumbersUsingSameGardenTimes:(NUUInt64)aTimes withCountPerSave:(NUUInt64)anObjectCountPerSave
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    NULibrary *aLibrary = [NULibrary library];
    [aGarden setRoot:aLibrary];

    for (NUUInt64 i = 0; i < aTimes; i++)
    {
        @autoreleasepool
        {
            NUUInt64 j = i * anObjectCountPerSave;
            NUUInt64 k = (i + 1) * anObjectCountPerSave;
            
            for (; j < k; j++)
            {
                NSNumber *aNumber = @(j);
                [aLibrary setObject:aNumber forKey:aNumber];
            }
            
            XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded);
        }
    }
}

- (void)_testSaveManyNSNumbersUsingDifferentGardensTimes:(NUUInt64)aTimes withCountPerSave:(NUUInt64)anObjectCountPerSave
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    for (NUUInt64 i = 0; i < aTimes; i++)
    {
        @autoreleasepool
        {
            NUGarden *aGarden = [aNursery makeGarden];
            NULibrary *aLibrary = nil;
            
            if (i == 0)
            {
                aLibrary = [NULibrary library];
                [aGarden setRoot:aLibrary];
            }
            else
                aLibrary = [aGarden root];
            
            NUUInt64 j = i * anObjectCountPerSave;
            NUUInt64 k = (i + 1) * anObjectCountPerSave;
            
            for (; j < k; j++)
            {
                NSNumber *aNumber = @(j);
                [aLibrary setObject:aNumber forKey:aNumber];
            }
            
            XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded);
        }
    }
}

- (void)testLoadRootFromNUNursery
{
	NSString *theRootObject = @"The Root Object";
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden setRoot:theRootObject];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        XCTAssertEqualObjects(theRootObject, [aGarden root], @"");
    };
	
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    XCTAssertEqualObjects([aGarden root], theRootObject, @"");
}

- (void)testSaveAndLoadNumberFromNUNursery
{
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NSNumber *aNumber = [NSNumber numberWithUnsignedLongLong:1];
    NUGarden *aGarden = [aNursery makeGarden];
    [aGarden setRoot:aNumber];
	XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    NUGarden *aGarden2 = [aNursery makeGarden];
    XCTAssertEqualObjects(aNumber, [aGarden2 root], @"");
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
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden setRoot:anArray];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        
        [anArray addObject:@"ObjectWorks"];
        [aGarden markChangedObject:anArray];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        
        [anArray addObject:@"VisualWorks"];
        [aGarden markChangedObject:anArray];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        
        [anArray addObject:@"Squeak"];
        [aGarden markChangedObject:anArray];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");

        [anArray addObject:@"Pharo"];
        [aGarden markChangedObject:anArray];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        
        NSDate *aDate = [NSDate date];
        [anArray addObject:aDate];
        [aGarden markChangedObject:anArray];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
	aLoadedArray = [aGarden root];
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
        NUGarden *aGarden = [aNursery makeGarden];
        
        [aGarden setRoot:anArray];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    NSArray *aLoadedArray = [aGarden root];
    
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
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden setRoot:aMutableSet];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    NSMutableSet *aLoadedMutableSet = [aGarden root];
    
    XCTAssertEqualObjects(aLoadedMutableSet, aMutableSet, @"");
    [aLoadedMutableSet addObject:@"aString2"];
}

- (void)testSaveLargeObject
{
    const int aMaxCount = 1000000;
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    
    NSMutableArray *anArray = [NSMutableArray array];
    int i = 0;
    for (; i < aMaxCount; i++)
        [anArray addObject:[NSString stringWithFormat:@"%06d", i]];
    [aGarden setRoot:anArray];
    
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
}

- (void)testSaveAndLoadLargeObject
{
    const int aMaxCount = 100000;//45000;
    NSMutableArray *anArray = [NSMutableArray array];

    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        
        int i = 0;
        for (; i < aMaxCount; i++)
            [anArray addObject:[NSString stringWithFormat:@"%06d", i]];
        [aGarden setRoot:anArray];
        
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"[aGarden farmOut] failed");
    }
    
	NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
	NSMutableArray *aUserRoot = [aGarden root];
	
	XCTAssertFalse(anArray == aUserRoot, @"");
	XCTAssertEqualObjects(anArray, aUserRoot, @"");
}

- (void)testSaveAndLoadMutableString
{
    NSMutableString *aMutableString = [[@"string" mutableCopy] autorelease];

    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden setRoot:aMutableString];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"[aNursery save] failed");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
	NSMutableString *aUserRoot = [aGarden root];
	
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
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden setRoot:aLibrary];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"[aGarden farmOut] failed");
    }

    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    aLibrary = [aGarden root];
    
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
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden setRoot:aPerson];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    XCTAssertTrue([aPerson retainCount] == 1, @"");
    [aPerson release];
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        aPerson = [[aGarden root] retain];
    //    NUBell *aPersonBell = [aPerson bell];
    //    NSMutableSet *anOOPSet = [aGarden bellSet];
    //    NSLog(@"%@", aPersonBell);
    //    NSLog(@"%@", anOOPSet);
    }
    
    XCTAssertTrue([aPerson retainCount] == 1, @"");
    [aPerson release];
}



- (void)testUpgradeCharacter
{
    Person *aPerson0 = nil, *aPerson1 = nil, *aPerson2 = nil;
    CharacterTargetClassResolver *aCharacterTargetClassResolver = [[CharacterTargetClassResolver new] autorelease];
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        NSMutableArray *aPersons = [NSMutableArray array];

        aPerson0 = [[Person alloc] initWithFirstName:@"aFirstName0" lastName:@"aLastName0"];
        [aPersons addObject:aPerson0];
        [aGarden setRoot:aPersons];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];

        [aGarden addCharacterTargetClassResolver:aCharacterTargetClassResolver];
        [Person setCharacterVersion:1];
        NSMutableArray *aPersons = [aGarden root];
        aPerson1 = [[Person alloc] initWithFirstName:@"aFirstName1" lastName:@"aLastName1"];
        [aPerson1 setMiddleName:@"aMiddleName1"];
        [aPersons addObject:aPerson1];
        [aGarden markChangedObject:aPersons];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        [Person setCharacterVersion:2];
        [aGarden addCharacterTargetClassResolver:aCharacterTargetClassResolver];
        NSMutableArray *aPersons = [aGarden root];
        aPerson2 = [[Person alloc] initWithFirstName:@"aFirstName2" lastName:@"aLastName2"];
        [aPerson2 setMiddleName:@"aMiddleName2"];
        [aPerson2 setAge:11];
        [aPersons addObject:aPerson2];
        [aGarden markChangedObject:aPersons];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden addCharacterTargetClassResolver:aCharacterTargetClassResolver];
        NSMutableArray *aPersons = [aGarden root];

        [Person setCharacterVersion:0];
        XCTAssertEqualObjects(aPersons[0], aPerson0, @"");
        [Person setCharacterVersion:1];
        XCTAssertEqualObjects(aPersons[1], aPerson1, @"");
        [Person setCharacterVersion:2];
        XCTAssertEqualObjects(aPersons[2], aPerson2, @"");
        
        [aPersons[0] setMiddleName:@"aMiddleName0"];
        [aGarden markChangedObject:aPersons[0]];
        [aPersons[1] setMiddleName:@"aMiddleName1-2"];
        [aGarden markChangedObject:aPersons[1]];
        [aPersons[2] setMiddleName:@"aMiddleName2-2"];
        [aGarden markChangedObject:aPersons[2]];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        [aPerson0 autorelease];
        [aPerson1 autorelease];
        [aPerson2 autorelease];
    }
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden addCharacterTargetClassResolver:aCharacterTargetClassResolver];
        NSMutableArray *aPersons = [aGarden root];
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
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden setRoot:anObject];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    XCTAssertEqualObjects([aGarden root], anObject);
}

- (void)testAllTypesObjectWithKeyedCoding
{
    [AllTypesObject setUseKeyedCoding:YES];
    
    AllTypesObject *anObject = [[AllTypesObject new] autorelease];
    
    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        [aGarden setRoot:anObject];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    XCTAssertEqualObjects([aGarden root], anObject);
}

- (void)testMakeGardenWithGrade
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    
    [aGarden setRoot:@"NextStep"];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    NUGarden *aGardenWithPastGrade1 = [aNursery makeGardenWithGrade:[aGarden grade]];
    
    [aGarden setRoot:@"NeXTstep"];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    NUGarden *aGardenWithPastGrade2 = [aNursery makeGardenWithGrade:[aGarden grade]];
    
    [aGarden setRoot:@"NeXTSTEP"];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    NUGarden *aGardenWithPastGrade3 = [aNursery makeGardenWithGrade:[aGarden grade]];
    
    [aGarden setRoot:@"NEXTSTEP"];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    NUGarden *aGardenWithPastGrade4 = [aNursery makeGardenWithGrade:[aGarden grade]];
    
    XCTAssertEqualObjects([aGardenWithPastGrade1 root], @"NextStep");
    XCTAssertEqualObjects([aGardenWithPastGrade2 root], @"NeXTstep");
    XCTAssertEqualObjects([aGardenWithPastGrade3 root], @"NeXTSTEP");
    XCTAssertEqualObjects([aGardenWithPastGrade4 root], @"NEXTSTEP");
}

- (void)testMoveUp
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    
    [aGarden setRoot:[[@"first" mutableCopy] autorelease]];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUGarden *aGardenA = [aNursery makeGarden];
    NUGarden *aGardenB = [aNursery makeGarden];
    
    [(NSMutableString *)[aGardenA root] setString:@"A"];
    [aGardenA markChangedObject:[aGardenA root]];
    
    [(NSMutableString *)[aGardenB root] setString:@"B"];
    [aGardenB markChangedObject:[aGardenB root]];
    
    XCTAssertEqual([aGardenA farmOut], NUFarmOutStatusSucceeded, @"");
    
    XCTAssertEqual([aGardenB farmOut], NUFarmOutStatusNurseryGradeUnmatched, @"");
    
    [aGardenB moveUp];
    [aGardenB moveUpObject:[aGardenB root]];
    XCTAssertEqualObjects([aGardenB root], @"A");
    [(NSMutableString *)[aGardenB root] setString:@"B"];
    [aGardenB markChangedObject:[aGardenB root]];
    
    XCTAssertEqual([aGardenB farmOut], NUFarmOutStatusSucceeded, @"");
}

@class NUNSNumber;

- (void)testMoveUpOfMutableArray
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    
    [aGarden setRoot:[NSMutableArray array]];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUGarden *aGardenA = [aNursery makeGarden];
    NSMutableArray *aMutableArray = [aGardenA root];
    [aMutableArray addObject:@(1)];
    [aGardenA markChangedObject:aMutableArray];
    XCTAssertEqual([aGardenA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [aGarden moveUp];
    [aGarden moveUpObject:[aGarden root]];
    
//    NSLog(@"[[aNursery garden] root]:%@, [aGardenA root]:%@", [[aNursery garden] root], [aGardenA root]);
    
    XCTAssertEqualObjects([aGarden root], [aGardenA root]);
}

- (void)testMoveUpOfMutableDictionary
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    
    [aGarden setRoot:[NSMutableDictionary dictionary]];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUGarden *aGardenA = [aNursery makeGarden];
    NSMutableDictionary *aMutableDictionary = [aGardenA root];
    [aMutableDictionary setObject:@(1) forKey:@(1)];
    [aGardenA markChangedObject:aMutableDictionary];
    XCTAssertEqual([aGardenA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [aGarden moveUp];
    [aGarden moveUpObject:[aGarden root]];
    
    XCTAssertEqualObjects([aGarden root], [aGardenA root]);
}

- (void)testMoveUpOfMutableSet
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    
    [aGarden setRoot:[NSMutableSet set]];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUGarden *aGardenA = [aNursery makeGarden];
    NSMutableSet *aMutableSet = [aGardenA root];
    [aMutableSet addObject:@(1)];
    [aGardenA markChangedObject:aMutableSet];
    XCTAssertEqual([aGardenA farmOut], NUFarmOutStatusSucceeded, @"");
    
    [aGarden moveUp];
    [aGarden moveUpObject:[aGarden root]];
    
    XCTAssertEqualObjects([aGarden root], [aGardenA root]);
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
    NUGarden *aGarden = nil;
    NUUInt64 aRootOOP = 0;
    
    @autoreleasepool
    {
        aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        aGarden = [aNursery makeGarden];
        
        
        [aGarden setRoot:anObject];
        
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        
        aRootOOP = [[aGarden bellForObject:[aGarden root]] OOP];
        
        [aGarden setRoot:aNewObject];

        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
        
        [NSThread sleepForTimeInterval:5];
        NUBell *aBell = [aGarden bellForOOP:aRootOOP];
        XCTAssertEqual([aBell retainCount], anExpectedRetainCount);
//        NSLog(@"retainCount of %@ is %@", aBell, @([aBell retainCount]));
    }
}

- (void)testSaveEmptyLazyMutableArray
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NULazyMutableArray *aLazyArray = [NULazyMutableArray array];
    NUGarden *aGarden = [aNursery makeGarden];
    [aGarden setRoot:aLazyArray];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    NUGarden *aGarden2 = [aNursery makeGarden];
    XCTAssertEqualObjects(aLazyArray, [aGarden2 root], @"");
}

- (void)testSaveLazyMutableArray
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NULazyMutableArray *aLazyArray = [NULazyMutableArray array];
    NUGarden *aGarden = [aNursery makeGarden];
    [aGarden setRoot:aLazyArray];
    [aLazyArray addObject:@"first"];
    XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    NUGarden *aGarden2 = [aNursery makeGarden];
    XCTAssertEqualObjects(aLazyArray, [aGarden2 root], @"");
}

@end
