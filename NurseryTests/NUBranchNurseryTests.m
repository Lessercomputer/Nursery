//
//  NUBranchNurseryTests.m
//  Nursery
//
//  Created by P,T,A on 2013/12/20.
//
//

#import <XCTest/XCTest.h>
#import <Nursery/Nursery.h>
#import "Person.h"

static NSString *NUNurseryTestFilePath;
@interface NUBranchNurseryTests : XCTestCase
@end

@implementation NUBranchNurseryTests

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

- (void)testBranchNurseryCallFor
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[aMainBranchNursery sandbox] setRoot:@"theRoot"];
    XCTAssertEqual([[aMainBranchNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    
    [[NUMainBranchNurseryAssociation defaultAssociation] setNursery:aMainBranchNursery forName:@"nursery"];
    
    NUBranchNurseryAssociation *aBranchAssociation = [NUBranchNurseryAssociation association];
    NUBranchNursery *aBranchNursery = [aBranchAssociation nurseryForURL:[NUNurseryAssociation URLWithHostName:nil associationName:NUDefaultMainBranchAssociation nurseryName:@"nursery"]];
    
    XCTAssertEqualObjects([[aBranchNursery sandbox] root], @"theRoot", @"");
    
    [aBranchAssociation close];
    
    [[NUMainBranchNurseryAssociation defaultAssociation] removeNurseryForName:@"nursery"];
    [aMainBranchNursery close];
}

- (void)testBranchNurseryFarmOut
{
    NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[NUMainBranchNurseryAssociation defaultAssociation] setNursery:aMainBranchNursery forName:@"nursery"];
    
    NUBranchNurseryAssociation *aBranchAssociation = [NUBranchNurseryAssociation association];
    NUBranchNursery *aBranchNursery = [aBranchAssociation nurseryForURL:[NUNurseryAssociation URLWithHostName:nil associationName:NUDefaultMainBranchAssociation nurseryName:@"nursery"]];
    
    [[aBranchNursery sandbox] setRoot:@"theRoot"];
    XCTAssertEqual([[aBranchNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [aBranchAssociation close];
    
    [[NUMainBranchNurseryAssociation defaultAssociation] removeNurseryForName:@"nursery"];
    [aMainBranchNursery close];
}

- (void)testBranchNurseryFarmOutAndCallFor
{
	NUMainBranchNursery *aMainBranchNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    [[NUMainBranchNurseryAssociation defaultAssociation] setNursery:aMainBranchNursery forName:@"nursery"];
    
    NUBranchNurseryAssociation *aBranchAssociation = [NUBranchNurseryAssociation association];
    NUBranchNursery *aBranchNursery = [aBranchAssociation nurseryForURL:[NUNurseryAssociation URLWithHostName:nil associationName:NUDefaultMainBranchAssociation nurseryName:@"nursery"]];
    
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
    
    [aBranchAssociation close];
    
    [[NUMainBranchNurseryAssociation defaultAssociation] removeNurseryForName:@"nursery"];
    [aMainBranchNursery close];
}

@end
