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
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];

    [super tearDown];
}

- (void)testBranchNurseryCallFor
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[aMainBranchNursery sandbox] setRoot:@"theRoot"];
    XCTAssertEqual([[aMainBranchNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandbox = [aMainBranchNursery createSandbox];
    XCTAssertEqualObjects([aSandbox root], @"theRoot");
    [aSandbox close];
    
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
    NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];
    XCTAssertEqualObjects([[aBranchNursery sandbox] root], @"theRoot", @"");

    [aNurseryNetService stop];
    
    [[aBranchNursery sandbox] close];
    [[aMainBranchNursery sandbox] close];
}

- (void)testBranchNurseryFarmOut
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
        
    NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];
    
    [[aBranchNursery sandbox] setRoot:@"theRoot"];
    XCTAssertEqual([[aBranchNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    [aNurseryNetService stop];
    
    [[aBranchNursery sandbox] close];
    [[aMainBranchNursery sandbox] close];
}

- (void)testBranchNurseryFarmOutAndCallFor
{
	NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
//    [[NUMainBranchNurseryAssociation defaultAssociation] setNursery:aMainBranchNursery forName:@"nursery"];
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
//    NUBranchNurseryAssociation *aBranchAssociation = [NUBranchNurseryAssociation association];
//    NUBranchNursery *aBranchNursery = [aBranchAssociation nurseryForURL:[NUNurseryAssociation URLWithHostName:nil associationName:NUDefaultMainBranchAssociation nurseryName:@"nursery"]];
    NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];

    NUSandbox *aBranchSandbox2 = [aBranchNursery createSandbox];
    NUSandbox *aBranchSandbox3 = [aBranchNursery createSandbox];
    NUSandbox *aBranchSandbox4 = [aBranchNursery createSandbox];
    NUSandbox *aBranchSandbox5 = [aBranchNursery createSandbox];
    
    [[aBranchNursery sandbox] setRoot:@"theRoot"];
    XCTAssertEqual([[aBranchNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
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
    
    [aBranchSandbox2 close];
    [aBranchSandbox3 close];
    [aBranchSandbox4 close];
    [aBranchSandbox5 close];
    
//    [aBranchAssociation close];
    [aNurseryNetService stop];
    
//    [[NUMainBranchNurseryAssociation defaultAssociation] removeNurseryForName:@"nursery"];
    [aMainBranchNursery close];
}

- (void)testBranchNurseryMoveUp
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
//    [[NUMainBranchNurseryAssociation defaultAssociation] setNursery:aMainBranchNursery forName:@"nursery"];
    NUNurseryNetService *aNurseryNetService = [NUNurseryNetService netServiceWithNursery:aMainBranchNursery serviceName:@"nursery"];
    
    [aNurseryNetService start];
    
//    NUBranchNurseryAssociation *aBranchAssociation = [NUBranchNurseryAssociation association];
//    NUBranchNursery *aBranchNursery = [aBranchAssociation nurseryForURL:[NUNurseryAssociation URLWithHostName:nil associationName:NUDefaultMainBranchAssociation nurseryName:@"nursery"]];
    
    NUBranchNursery *aBranchNursery = [NUBranchNursery branchNurseryWithServiceName:@"nursery"];

    [[aBranchNursery sandbox] setRoot:[[@"first" mutableCopy] autorelease]];
    XCTAssertEqual([[aBranchNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    NUSandbox *aSandboxA = [aBranchNursery createSandbox];
    NUSandbox *aSandboxB = [aBranchNursery createSandbox];
    
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
    [[aBranchNursery sandbox] close];
    
//    [aBranchAssociation close];
    
//    [[NUMainBranchNurseryAssociation defaultAssociation] removeNurseryForName:@"nursery"];
    
    [aNurseryNetService stop];
    
    [[aMainBranchNursery sandbox] close];
}

@end
