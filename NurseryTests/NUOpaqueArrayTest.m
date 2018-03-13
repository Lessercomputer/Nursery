//
//  NUOpaqueArrayTest.m
//  Nursery
//
//  Created by Akifumi Takata on 11/03/24.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Nursery/Nursery.h>
#import "NUOpaqueArray.h"

@interface NUOpaqueArrayTest : XCTestCase

@end

@implementation NUOpaqueArrayTest

- (void)testNUDataArrayInsertion
{
	NUOpaqueArray *aDataArray = [[[NUOpaqueArray alloc] initWithValueLength:1 capacity:50] autorelease];
	[aDataArray insert:(NUUInt8 *)"a" to:0];
	[aDataArray insert:(NUUInt8 *)"b" to:0];
	XCTAssertTrue(*[aDataArray at:0] == 'b', @"");
	XCTAssertTrue(*[aDataArray at:1] == 'a', @"");
	
	aDataArray = [[[NUOpaqueArray alloc] initWithValueLength:1 capacity:50] autorelease];
	[aDataArray insert:(NUUInt8 *)"a" to:0];
	[aDataArray insert:(NUUInt8 *)"b" to:1];
	XCTAssertTrue(*[aDataArray at:0] == 'a', @"");
	XCTAssertTrue(*[aDataArray at:1] == 'b', @"");
	
	aDataArray = [[[NUOpaqueArray alloc] initWithValueLength:1 capacity:50] autorelease];
	XCTAssertThrows([aDataArray insert:(NUUInt8 *)"a" to:50], @"");
	
	aDataArray = [[[NUOpaqueArray alloc] initWithValueLength:1 capacity:50] autorelease];
	[aDataArray insert:(NUUInt8 *)"a" to:0];
	[aDataArray insert:(NUUInt8 *)"b" to:1];
	[aDataArray insert:(NUUInt8 *)"c" to:2];
	[aDataArray insert:(NUUInt8 *)"d" to:1];
	XCTAssertTrue([aDataArray count] == 4, @"");
	XCTAssertTrue(*[aDataArray at:0] == 'a', @"");
	XCTAssertTrue(*[aDataArray at:1] == 'd', @"");
	XCTAssertTrue(*[aDataArray at:2] == 'b', @"");
	XCTAssertTrue(*[aDataArray at:3] == 'c', @"");
}

- (void)testNUDataArrayRemoving
{
	NUOpaqueArray *aDataArray = [[[NUOpaqueArray alloc] initWithValueLength:1 capacity:50] autorelease];
	[aDataArray insert:(NUUInt8 *)"a" to:0];
	[aDataArray insert:(NUUInt8 *)"b" to:1];
	[aDataArray removeAt:0];
	XCTAssertTrue([aDataArray count] == 1, @"");
	XCTAssertTrue(*[aDataArray at:0] == 'b', @"");
	XCTAssertThrows([aDataArray removeAt:1], @"");
	[aDataArray removeAt:0];
	XCTAssertTrue([aDataArray count] == 0, @"");
}

- (void)testNUDataArraySetDataFrom
{
	NUOpaqueArray *aDataArray = [[[NUOpaqueArray alloc] initWithValueLength:1 capacity:50] autorelease];
	[aDataArray setOpaqueValues:(NUUInt8 *)"abc" count:3];
	XCTAssertTrue([aDataArray count] == 3, @"");
	XCTAssertTrue(*[aDataArray at:0] == 'a', @"");
	XCTAssertTrue(*[aDataArray at:1] == 'b', @"");
	XCTAssertTrue(*[aDataArray at:2] == 'c', @"");
}

- (void)testBtreeSupport
{
//    NUOpaqueArray *anOpaqueArray = [[[NUOpaqueArray alloc] initWithValueLength:sizeof(NUUInt64) capacity:2] autorelease];
//    NUOpaqueArray *anInsertedArray = nil;
//    NUOpaqueArray *aNewArray = nil;
//    NUUInt32 anIndex = 0;
//    
//    NUUInt64 aValues[] = {0, 1, 2, 3, 4};
//    
//    [anOpaqueArray add:(NUUInt8 *)&aValues[0]];
//    [anOpaqueArray add:(NUUInt8 *)&aValues[2]];
//    
//    aNewArray = [anOpaqueArray insert:(NUUInt8 *)&aValues[1] to:0 insertedTo:&anInsertedArray at:&anIndex];
//    
//    STAssertTrue([anOpaqueArray count] == 1, nil);
//    STAssertTrue([aNewArray count] == 2, nil);
//    STAssertTrue(*(NUUInt64 *)[anOpaqueArray at:0] == 1, nil);
//    STAssertTrue(*(NUUInt64 *)[aNewArray at:0] == 0, nil);
//    STAssertTrue(*(NUUInt64 *)[aNewArray at:1] == 2, nil);
    
//    [anOpaqueArray add:(NUUInt8 *)&aValues[2]];
}

@end
