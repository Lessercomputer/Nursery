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
    
    [NSThread sleepForTimeInterval:0.1];
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

@end
