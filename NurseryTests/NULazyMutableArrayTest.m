//
//  NULazyMutableArrayTest.m
//  NurseryTests
//
//  Created by Akifumi Takata on 2018/05/24.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NULazyMutableArray.h"

@interface NULazyMutableArrayTest : XCTestCase

@end

@implementation NULazyMutableArrayTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testArray
{
    id anArray = [NULazyMutableArray array];
    XCTAssertTrue([anArray isKindOfClass:[NULazyMutableArray class]]);
}

- (void)testArrayWithCapacity
{
    NULazyMutableArray *aLazyArray = [NULazyMutableArray arrayWithCapacity:3];
    [aLazyArray addObject:@(0)];
    [aLazyArray addObject:@(1)];
    [aLazyArray addObject:@(2)];
    [aLazyArray addObject:@(3)];
}

- (void)testSubLazyMutableArrayWithRange
{
    NULazyMutableArray *aLazyArray = [NULazyMutableArray array];
    [aLazyArray addObject:@(0)];
    [aLazyArray addObject:@(1)];
    [aLazyArray addObject:@(2)];
    [aLazyArray addObject:@(3)];
    id aSubArray = [aLazyArray subLazyMutableArrayWithRange:NSMakeRange(0, 2)];
    XCTAssertTrue([aSubArray isKindOfClass:[NULazyMutableArray class]]);
}

- (void)testInsert
{
    NULazyMutableArray *aLazyArray = [[[NULazyMutableArray alloc] init] autorelease];
    
    for (NSInteger i = 9; i >= 0; i--)
        [aLazyArray insertObject:@(i) atIndex:0];
    
    XCTAssertEqual([aLazyArray count], 10);
    
    for (NSUInteger i = 0; i < 10; i++)
        XCTAssertEqualObjects([aLazyArray objectAtIndex:i], @(i));
}

- (void)testAdd
{
    NULazyMutableArray *aLazyArray = [[[NULazyMutableArray alloc] init] autorelease];
    
    for (NSUInteger i = 0; i < 10; i++)
        [aLazyArray addObject:@(i)];

    XCTAssertEqual([aLazyArray count], 10);
    
    for (NSUInteger i = 0; i < 10; i++)
        XCTAssertEqualObjects([aLazyArray objectAtIndex:i], @(i));
}

- (void)testRemove
{
    NULazyMutableArray *aLazyArray = [[[NULazyMutableArray alloc] init] autorelease];
    
    for (NSUInteger i = 0; i < 10; i++)
        [aLazyArray addObject:@(i)];
    
    [aLazyArray removeObjectAtIndex:0];
    XCTAssertEqualObjects([aLazyArray objectAtIndex:0], @(1));
    XCTAssertEqual([aLazyArray count], 9);
    
    [aLazyArray removeObjectAtIndex:0];
    XCTAssertEqualObjects([aLazyArray objectAtIndex:0], @(2));
    XCTAssertEqual([aLazyArray count], 8);
    
    [aLazyArray removeObjectAtIndex:0];
    XCTAssertEqualObjects([aLazyArray objectAtIndex:0], @(3));
    XCTAssertEqual([aLazyArray count], 7);
}

- (void)testRemoveLast
{
    NULazyMutableArray *aLazyArray = [[[NULazyMutableArray alloc] init] autorelease];
    
    for (NSUInteger i = 0; i < 10; i++)
        [aLazyArray addObject:@(i)];
    
    for (NSUInteger i = 0; i < 10; i++)
    {
        [aLazyArray removeLastObject];
        XCTAssertEqual([aLazyArray count], 10 - i - 1);
    }
    
    XCTAssertEqual([aLazyArray count], 0);
}

- (void)testReplace
{
    NULazyMutableArray *aLazyArray = [[[NULazyMutableArray alloc] init] autorelease];
    
    [aLazyArray addObject:@(0)];
    [aLazyArray addObject:@(1)];
    [aLazyArray addObject:@(2)];
    
    id anObject = [aLazyArray firstObject];
    id anObject2 = [aLazyArray lastObject];
    
    [aLazyArray replaceObjectAtIndex:0 withObject:anObject2];
    [aLazyArray replaceObjectAtIndex:2 withObject:anObject];
    
    XCTAssertEqualObjects([aLazyArray objectAtIndex:0], @(2));
    XCTAssertEqualObjects([aLazyArray objectAtIndex:1], @(1));
    XCTAssertEqualObjects([aLazyArray objectAtIndex:2], @(0));
}

- (void)testAddPeformance
{
    NULazyMutableArray *aLazyArray = [[[NULazyMutableArray alloc] init] autorelease];
    
    [self measureBlock:^{
        for (NSUInteger i = 0; i < 1000000; i++)
            [aLazyArray addObject:@(0)];
    }];
}

- (void)testAddPeformanceOfNSMutableArray
{
    NSMutableArray *anArray = [[[NSMutableArray alloc] init] autorelease];
    
    [self measureBlock:^{
        for (NSUInteger i = 0; i < 1000000; i++)
            [anArray addObject:@(0)];
    }];
}

@end
