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
    
    [[aMainBranchNursery playLot] setRoot:@"theRoot"];
    XCTAssertEqual([[aMainBranchNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    
    [[NUMainBranchNurseryAssociation defaultAssociation] setNursery:aMainBranchNursery forName:@"nursery"];
    
    NUBranchNurseryAssociation *aBranchAssociation = [NUBranchNurseryAssociation association];
    NUBranchNursery *aBranchNursery = [aBranchAssociation nurseryForURL:[NUNurseryAssociation URLWithHostName:nil associationName:NUDefaultMainBranchAssociation nurseryName:@"nursery"]];
    
    XCTAssertEqualObjects([[aBranchNursery playLot] root], @"theRoot", @"");
    
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
    
    [[aBranchNursery playLot] setRoot:@"theRoot"];
    XCTAssertEqual([[aBranchNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
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
    
    NUPlayLot *aBranchPlayLot2 = [aBranchNursery createPlayLot];
    NUPlayLot *aBranchPlayLot3 = [aBranchNursery createPlayLot];
    NUPlayLot *aBranchPlayLot4 = [aBranchNursery createPlayLot];
    NUPlayLot *aBranchPlayLot5 = [aBranchNursery createPlayLot];
    
    [[aBranchNursery playLot] setRoot:@"theRoot"];
    XCTAssertEqual([[aBranchNursery playLot] farmOut], NUFarmOutStatusSucceeded, @"");
    
    XCTAssertEqualObjects([aBranchPlayLot2 root], @"theRoot", @"");
    
    [aBranchPlayLot3 setRoot:@"theRoot3"];
    XCTAssertEqual([aBranchPlayLot3 farmOut], NUFarmOutStatusSucceeded, @"");
    XCTAssertEqualObjects([aBranchPlayLot3 root], @"theRoot3", @"");
    XCTAssertEqualObjects([aBranchPlayLot4 root], @"theRoot3", @"");
    
    [aBranchPlayLot2 setRoot:@"theRoot2"];
    NSString *theRoot2 = [[[aBranchPlayLot2 root] retain] autorelease];
    XCTAssertEqual([aBranchPlayLot2 farmOut], NUFarmOutStatusNurseryGradeUnmatched, @"");
    [aBranchPlayLot2 moveUp];
    XCTAssertEqualObjects([aBranchPlayLot2 root], @"theRoot3", @"");
    [aBranchPlayLot2 setRoot:theRoot2];
    XCTAssertEqualObjects([aBranchPlayLot2 root], @"theRoot2", @"");
    XCTAssertTrue([aBranchPlayLot2 gradeIsEqualToNurseryGrade], @"");
    XCTAssertEqual([aBranchPlayLot2 farmOut], NUFarmOutStatusSucceeded, @"");
    XCTAssertEqualObjects([aBranchPlayLot2 root], @"theRoot2", @"");
    
    XCTAssertEqualObjects([aBranchPlayLot5 root], @"theRoot2", @"");
    
    [aBranchPlayLot2 close];
    [aBranchPlayLot3 close];
    [aBranchPlayLot4 close];
    [aBranchPlayLot5 close];
    
    [aBranchAssociation close];
    
    [[NUMainBranchNurseryAssociation defaultAssociation] removeNurseryForName:@"nursery"];
    [aMainBranchNursery close];
}

@end
