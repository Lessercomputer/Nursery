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

@interface NUBranchNurseryTests : XCTestCase
@end

@implementation NUBranchNurseryTests

- (void)setUp
{
    [super setUp];
    NUNurseryTestFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"nursery.nursery"];
    [[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];
    [NSThread sleepForTimeInterval:0.1];
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];

    [super tearDown];
}

- (void)testBranchNurseryCallFor
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUSandbox *aMainBranchSandbox = [aMainBranchNursery makeSandbox];
    
    [aMainBranchSandbox setRoot:@"theRoot"];
    XCTAssertEqual([aMainBranchSandbox farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandbox = [aMainBranchNursery makeSandbox];
    XCTAssertEqualObjects([aSandbox root], @"theRoot");
    
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    @autoreleasepool
    {
        NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];
        NUSandbox *aBranchSandbox = [aBranchNursery makeSandbox];
        XCTAssertEqualObjects([aBranchSandbox root], @"theRoot", @"");
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
        NUSandbox *aBranchSandbox = [aBranchNursery makeSandbox];
        [aBranchSandbox setRoot:@"theRoot"];
        XCTAssertEqual([aBranchSandbox farmOut], NUFarmOutStatusSucceeded, @"");
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

        NUSandbox *aBranchSandbox1 = [aBranchNursery makeSandbox];
        NUSandbox *aBranchSandbox2 = [aBranchNursery makeSandbox];
        NUSandbox *aBranchSandbox3 = [aBranchNursery makeSandbox];
        NUSandbox *aBranchSandbox4 = [aBranchNursery makeSandbox];
        NUSandbox *aBranchSandbox5 = [aBranchNursery makeSandbox];
        
        [aBranchSandbox1 setRoot:@"theRoot"];
        XCTAssertEqual([aBranchSandbox1 farmOut], NUFarmOutStatusSucceeded, @"");
        
        XCTAssertEqualObjects([aBranchSandbox2 root], @"theRoot", @"");
        
        [aBranchSandbox3 setRoot:@"theRoot3"];
        XCTAssertEqual([aBranchSandbox3 farmOut], NUFarmOutStatusSucceeded, @"");
        XCTAssertEqualObjects([aBranchSandbox3 root], @"theRoot3", @"");
        XCTAssertEqualObjects([aBranchSandbox4 root], @"theRoot3", @"");
        
        [aBranchSandbox2 setRoot:@"theRoot2"];
        NSString *theRoot2 = [[[aBranchSandbox2 root] retain] autorelease];
        XCTAssertEqual([aBranchSandbox2 farmOut], NUFarmOutStatusNurseryGradeUnmatched, @"");
        [aBranchSandbox2 moveUp];
        XCTAssertEqualObjects([aBranchSandbox2 root], @"theRoot3", @"");
        [aBranchSandbox2 setRoot:theRoot2];
        XCTAssertEqualObjects([aBranchSandbox2 root], @"theRoot2", @"");
        XCTAssertTrue([aBranchSandbox2 gradeIsEqualToNurseryGrade], @"");
        XCTAssertEqual([aBranchSandbox2 farmOut], NUFarmOutStatusSucceeded, @"");
        XCTAssertEqualObjects([aBranchSandbox2 root], @"theRoot2", @"");
        
        XCTAssertEqualObjects([aBranchSandbox5 root], @"theRoot2", @"");
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
        NUSandbox *aBranchSandbox = [aBranchNursery makeSandbox];

        [aBranchSandbox setRoot:[[@"first" mutableCopy] autorelease]];
        XCTAssertEqual([aBranchSandbox farmOut], NUFarmOutStatusSucceeded, @"");
        
        NUSandbox *aSandboxA = [aBranchNursery makeSandbox];
        NUSandbox *aSandboxB = [aBranchNursery makeSandbox];
        
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
    
    [aNurseryNetService stop];
}

@end
