//
//  NURegionArrayTest.m
//  Nursery
//
//  Created by Akifumi Takata on 2012/09/07.
//
//

#import <XCTest/XCTest.h>
#import "NUChangedRegionArray.h"
#import <Nursery/NURegion.h>

@interface NURegionArrayTest : XCTestCase

@end

@implementation NURegionArrayTest

- (void)testAddRegion
{
    NUChangedRegionArray *anArray = [[[NUChangedRegionArray alloc] initWithCapacity:10] autorelease];
    
    [anArray addRegion:NUMakeRegion(10, 1)];
    XCTAssertTrue([anArray count] == 1, @"");
    
    NURegion aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 10 && aRegion.length == 1, @"");
    
    [anArray addRegion:NUMakeRegion(5, 2)];
    XCTAssertTrue([anArray count] == 2, @"");
    aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 5 && aRegion.length == 2, @"");
    aRegion = [anArray regionAt:1];
    XCTAssertTrue(aRegion.location == 10 && aRegion.length == 1, @"");
    
    [anArray addRegion:NUMakeRegion(15, 3)];
    XCTAssertTrue([anArray count] == 3, @"");
    aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 5 && aRegion.length == 2, @"");
    aRegion = [anArray regionAt:1];
    XCTAssertTrue(aRegion.location == 10 && aRegion.length == 1, @"");
    aRegion = [anArray regionAt:2];
    XCTAssertTrue(aRegion.location == 15 && aRegion.length == 3, @"");

    [anArray addRegion:NUMakeRegion(10, 1)];
    XCTAssertTrue([anArray count] == 3, @"");
    aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 5 && aRegion.length == 2, @"");
    aRegion = [anArray regionAt:1];
    XCTAssertTrue(aRegion.location == 10 && aRegion.length == 1, @"");
    aRegion = [anArray regionAt:2];
    XCTAssertTrue(aRegion.location == 15 && aRegion.length == 3, @"");

    [anArray addRegion:NUMakeRegion(4, 10)];
    XCTAssertTrue([anArray count] == 2, @"");
    aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 4 && aRegion.length == 10, @"");
    aRegion = [anArray regionAt:1];
    XCTAssertTrue(aRegion.location == 15 && aRegion.length == 3, @"");
    
    [anArray addRegion:NUMakeRegion(4, 14)];
    XCTAssertTrue([anArray count] == 1, @"");
    aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 4 && aRegion.length == 14, @"");
    
    [anArray addRegion:NUMakeRegion(0, 20)];
    XCTAssertTrue([anArray count] == 1, @"");
    aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 0  && aRegion.length == 20, @"");
    
    [anArray addRegion:NUMakeRegion(21, 3)];
    XCTAssertTrue([anArray count] == 2, @"");
    aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 0  && aRegion.length == 20, @"");
    aRegion = [anArray regionAt:1];
    XCTAssertTrue(aRegion.location == 21 && aRegion.length == 3, @"");
    
    [anArray addRegion:NUMakeRegion(18, 5)];
    XCTAssertTrue([anArray count], @"");
    aRegion = [anArray regionAt:0];
    XCTAssertTrue(aRegion.location == 0 && aRegion.length == 24, @"");
}

@end
