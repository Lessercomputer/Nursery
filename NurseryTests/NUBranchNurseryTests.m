//
//  NUBranchNurseryTests.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/12/20.
//
//

#import <XCTest/XCTest.h>
#import <Nursery/Nursery.h>
#import "Person.h"
#import "NUBranchNursery.h"
#import "NUGarden+Project.h"
#import "NUNurseryNetService.h"

static NSString *NUNurseryTestFilePath;
static NSString *NUNurseryTestFilePath2;

@interface NUBranchNurseryTests : XCTestCase
@end

@implementation NUBranchNurseryTests

- (void)setUp
{
    [super setUp];
    
    NUNurseryTestFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"nursery.nursery"];
    [[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];
    
    NUNurseryTestFilePath2 = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"nursery2.nursery"];
    [[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath2 error:nil];
    
    [NSThread sleepForTimeInterval:1];
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath2 error:nil];

    [super tearDown];
}

- (void)testNurseryNetServiceStartAndStop
{
    [self _testNurseryNetServiceStartAndStopTimes:1];
}

- (void)testNurseryNetServiceStartAndStop2Times
{
    [self _testNurseryNetServiceStartAndStopTimes:2];
}

- (void)_testNurseryNetServiceStartAndStopTimes:(NSUInteger)aTimes
{
    while (!aTimes && aTimes-- )
    {
        @autoreleasepool
        {
            NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
            NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
            
            [aNurseryNetService start];
            [aNurseryNetService stop];
        }
    }
}

- (void)testNurseryNetServiceStartSameServiceName
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    NUMainBranchNursery *aMainBranchNursery2 = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath2];
    NUNurseryNetService *aNurseryNetService2 = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery2 serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    [NSThread sleepForTimeInterval:1];
    
    XCTAssertThrowsSpecificNamed([aNurseryNetService2 start], NSException, NUNurseryNetServiceNetworkException);
    
    [aNurseryNetService stop];
}

- (void)testBranchNurseryCallFor
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aMainBranchGarden = [aMainBranchNursery makeGarden];
    
    [aMainBranchGarden setRoot:@"theRoot"];
    XCTAssertEqual([aMainBranchGarden farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUGarden *aGarden = [aMainBranchNursery makeGarden];
    XCTAssertEqualObjects([aGarden root], @"theRoot");
    
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    @autoreleasepool
    {
        NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];
        NUGarden *aBranchGarden = [aBranchNursery makeGarden];
        XCTAssertEqualObjects([aBranchGarden root], @"theRoot", @"");
    }
    
    [aNurseryNetService stop];
}

- (void)testBranchNurseryFarmOut
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    @autoreleasepool
    {
        NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];
        NUGarden *aBranchGarden = [aBranchNursery makeGarden];
        [aBranchGarden setRoot:@"theRoot"];
        XCTAssertEqual([aBranchGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    [aNurseryNetService stop];
}

- (void)testBranchNurseryFarmOutAndCallFor
{
	NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    @autoreleasepool
    {
        NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];

        NUGarden *aBranchGarden1 = [aBranchNursery makeGarden];
        NUGarden *aBranchGarden2 = [aBranchNursery makeGarden];
        NUGarden *aBranchGarden3 = [aBranchNursery makeGarden];
        NUGarden *aBranchGarden4 = [aBranchNursery makeGarden];
        NUGarden *aBranchGarden5 = [aBranchNursery makeGarden];
        
        [aBranchGarden1 setRoot:@"theRoot"];
        XCTAssertEqual([aBranchGarden1 farmOut], NUFarmOutStatusSucceeded, @"");
        
        XCTAssertEqualObjects([aBranchGarden2 root], @"theRoot", @"");
        
        [aBranchGarden3 setRoot:@"theRoot3"];
        XCTAssertEqual([aBranchGarden3 farmOut], NUFarmOutStatusSucceeded, @"");
        XCTAssertEqualObjects([aBranchGarden3 root], @"theRoot3", @"");
        XCTAssertEqualObjects([aBranchGarden4 root], @"theRoot3", @"");
        
        [aBranchGarden2 setRoot:@"theRoot2"];
        NSString *theRoot2 = [[[aBranchGarden2 root] retain] autorelease];
        XCTAssertEqual([aBranchGarden2 farmOut], NUFarmOutStatusNurseryGradeUnmatched, @"");
        [aBranchGarden2 moveUp];
        XCTAssertEqualObjects([aBranchGarden2 root], @"theRoot3", @"");
        [aBranchGarden2 setRoot:theRoot2];
        XCTAssertEqualObjects([aBranchGarden2 root], @"theRoot2", @"");
        XCTAssertTrue([aBranchGarden2 gradeIsEqualToNurseryGrade], @"");
        XCTAssertEqual([aBranchGarden2 farmOut], NUFarmOutStatusSucceeded, @"");
        XCTAssertEqualObjects([aBranchGarden2 root], @"theRoot2", @"");
        
        XCTAssertEqualObjects([aBranchGarden5 root], @"theRoot2", @"");
    }
    
    [aNurseryNetService stop];
}

- (void)testBranchNurseryMoveUp
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    @autoreleasepool
    {
        NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];
        NUGarden *aBranchGarden = [aBranchNursery makeGarden];

        [aBranchGarden setRoot:[[@"first" mutableCopy] autorelease]];
        XCTAssertEqual([aBranchGarden farmOut], NUFarmOutStatusSucceeded, @"");
        
        NUGarden *aGardenA = [aBranchNursery makeGarden];
        NUGarden *aGardenB = [aBranchNursery makeGarden];
        
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
    
    [aNurseryNetService stop];
}

- (void)testMoveUpOfNULibrary
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    @autoreleasepool
    {
        const NUUInt64 aCount = 10000;
        NUUInt64 aStartNo = 0;
        NUBranchNursery *aNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];
        NUGarden *aGardenA = [aNursery makeGarden];
        NULibrary *aLibraryA = [NULibrary library];
        NUGarden *aGardenB = [aNursery makeGarden];
        NULibrary *aLibraryB = nil;
        NUGarden *aGardenC = [aNursery makeGarden];
        NULibrary *aLibraryC = nil;
        
        [aGardenA setRoot:aLibraryA];
        for (NUUInt64 i = aStartNo; i < aCount; i++)
            [aLibraryA setObject:@(i) forKey:@(i)];
        XCTAssertEqual([aGardenA farmOut], NUFarmOutStatusSucceeded);
        
        aLibraryB = [aGardenB root];
        XCTAssertFalse([[aLibraryB bell] gradeIsUnmatched]);
        XCTAssertEqualObjects(aLibraryB, aLibraryA);
        aStartNo = [(NSNumber *)[aLibraryB lastKey] unsignedLongLongValue] + 1;
        for (NUUInt64 i = aStartNo; i < aStartNo + aCount; i++)
            [aLibraryB setObject:@(i) forKey:@(i)];
        XCTAssertFalse([[aLibraryB bell] gradeIsUnmatched]);
        XCTAssertNotEqualObjects(aLibraryB, aLibraryA);
        
        aStartNo = [(NSNumber *)[aLibraryA lastKey] unsignedLongLongValue] + 1;
        for (NUUInt64 i = aStartNo; i < aStartNo + aCount; i++)
            [aLibraryA setObject:@(i) forKey:@(i)];
        XCTAssertFalse([[aLibraryA bell] gradeIsUnmatched]);
        XCTAssertEqualObjects(aLibraryA, aLibraryB);
        XCTAssertEqual([aGardenA farmOut], NUFarmOutStatusSucceeded);
        
        XCTAssertEqual([aGardenB farmOut], NUFarmOutStatusNurseryGradeUnmatched);
        XCTAssertFalse([[aLibraryB bell] gradeIsUnmatched]);
        [aGardenB moveUp];
        XCTAssertTrue([[aLibraryB bell] gradeIsUnmatched]);
        [aLibraryB moveUp];
        XCTAssertFalse([[aLibraryB bell] gradeIsUnmatched]);
        XCTAssertEqualObjects(aLibraryB, aLibraryA);
        
        aStartNo = [(NSNumber *)[aLibraryB lastKey] unsignedLongLongValue] + 1;
        for (NUUInt64 i = aStartNo; i < aStartNo + aCount; i++)
            [aLibraryB setObject:@(i) forKey:@(i)];
        XCTAssertFalse([[aLibraryB bell] gradeIsUnmatched]);
        XCTAssertNotEqualObjects(aLibraryB, aLibraryA);
        XCTAssertEqual([aGardenB farmOut], NUFarmOutStatusSucceeded);
        XCTAssertFalse([[aLibraryB bell] gradeIsUnmatched]);
        
        aLibraryC = [aGardenC root];
        XCTAssertFalse([[aLibraryC bell] gradeIsUnmatched]);
        XCTAssertEqualObjects(aLibraryC, aLibraryB);
    }
    
    [aNurseryNetService stop];
}

- (void)testObjectResurrection
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    @autoreleasepool
    {
        NUBranchNursery *aNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];
        
        NUGarden *aGarden = [aNursery makeGarden];
        NSMutableString *aString = [[@"resurrection" mutableCopy] autorelease];
        NULibrary *aLibrary = [NULibrary library];
        [aLibrary setObject:aString forKey:aString];
        [aGarden setRoot:aLibrary];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded);
        
        NUGarden *aGardenA = [aNursery makeGarden];
        NULibrary *aRoot = [aGardenA root];
        
        NUGarden *aGardenB = [aNursery makeGarden];
        [aGardenB setRoot:nil];
        XCTAssertEqual([aGardenB farmOut], NUFarmOutStatusSucceeded);
        
        NUBell *aRootBellBeforeMoveUp = [aRoot bell];
        [aGardenA moveUpWithPreventingReleaseOfCurrentGrade];
        NUBell *aRootBellAfterMoveUp = [aRoot bell];
        XCTAssertEqualObjects([aGardenA root], nil);
        XCTAssertTrue(aRootBellAfterMoveUp == aRootBellBeforeMoveUp);
        
        [aGardenA setRoot:aRoot];
        XCTAssertEqual([aGardenA farmOut], NUFarmOutStatusSucceeded);
        NUBell *aRootBellAfterFarmOut = [aRoot bell];
        XCTAssertTrue(aRootBellAfterFarmOut == aRootBellBeforeMoveUp);
        XCTAssertEqualObjects(aRoot, aLibrary);
        
        NUGarden *aGardenC = [aNursery makeGarden];
        XCTAssertEqualObjects([aGardenC root], aLibrary);
    }
    
    [aNurseryNetService stop];
    
}

@end
