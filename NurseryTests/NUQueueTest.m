//
//  NUQueueTest.m
//  NurseryTests
//
//  Created by Akifumi Takata on 2017/11/27.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NUQueue.h"
#import "NUUInt64Queue.h"

@interface NUQueueTest : XCTestCase

@end

@implementation NUQueueTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPushAndPop
{
    NUQueue *aQueue = [NUQueue queue];
    NUUInt64 aCount = 1000000;
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        [aQueue push:@(i)];
        XCTAssertTrue([aQueue count] == i + 1);
    }
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        XCTAssertEqualObjects([aQueue pop], @(i));
        XCTAssertTrue([aQueue count] == aCount - i - 1);
    }
}

- (void)testPushAndPop2
{
    NUQueue *aQueue = [NUQueue queue];
    NUUInt64 aCount = 7;
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        [aQueue push:@(i)];
        XCTAssertTrue([aQueue count] == i + 1);
    }
    
    XCTAssertEqualObjects([aQueue pop], @(0));
    XCTAssertTrue([aQueue count] == 6);
    
    XCTAssertEqualObjects([aQueue pop], @(1));
    XCTAssertTrue([aQueue count] == 5);
    
    XCTAssertEqualObjects([aQueue pop], @(2));
    XCTAssertTrue([aQueue count] == 4);
    
    [aQueue push:@(7)];
    XCTAssertTrue([aQueue count] == 5);
    
    [aQueue push:@(8)];
    XCTAssertTrue([aQueue count] == 6);
    
    [aQueue push:@(9)];
    XCTAssertTrue([aQueue count] == 7);
    
    [aQueue push:@(10)];
    XCTAssertTrue([aQueue count] == 8);
    
    XCTAssertEqualObjects([aQueue pop], @(3));
    XCTAssertTrue([aQueue count] == 7);
}

- (void)testPushAndPopForNUUInt64Queue
{
    NUUInt64Queue *aQueue = [NUUInt64Queue queue];
    NUUInt64 aCount = 1000000;
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        [aQueue push:i];
        XCTAssertTrue([aQueue count] == i + 1);
    }
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        XCTAssertEqual([aQueue pop], i);
        XCTAssertTrue([aQueue count] == aCount - i - 1);
    }
}

- (void)testPushAndPop2ForNUUInt64Queue
{
    NUUInt64Queue *aQueue = [NUUInt64Queue queue];
    NUUInt64 aCount = 7;
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        [aQueue push:i];
        XCTAssertTrue([aQueue count] == i + 1);
    }
    
    XCTAssertEqual([aQueue pop], 0);
    XCTAssertTrue([aQueue count] == 6);
    
    XCTAssertEqual([aQueue pop], 1);
    XCTAssertTrue([aQueue count] == 5);
    
    XCTAssertEqual([aQueue pop], 2);
    XCTAssertTrue([aQueue count] == 4);
    
    [aQueue push:7];
    XCTAssertTrue([aQueue count] == 5);
    
    [aQueue push:8];
    XCTAssertTrue([aQueue count] == 6);
    
    [aQueue push:9];
    XCTAssertTrue([aQueue count] == 7);
    
    [aQueue push:10];
    XCTAssertTrue([aQueue count] == 8);
    
    XCTAssertEqual([aQueue pop], 3);
    XCTAssertTrue([aQueue count] == 7);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
