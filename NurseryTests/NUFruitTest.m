//
//  FruitTest.m
//  Nursery
//
//  Created by Akifumi Takata on 2019/01/16.
//  Copyright © 2019年 Nursery-Framework. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NUFruit.h"

@interface NUFruitTest : XCTestCase

@end

@implementation NUFruitTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testFruit {
    
    XCTAssertNotNil([NUFruit Fruit]);
}

- (void)testFruitIsAFruit {

    XCTAssertNotNil([[[[NUFruit Fruit] is] a] fruit]);
}

- (void)testFruitThen {
    
    XCTAssertNotNil([NUThen then]);
}

- (void)testFruitNo
{
    XCTAssertNotNil([NUNo No]);
}

- (void)testFruitDo
{
    XCTAssertNotNil([[NUFruit fruit] do]);
}

- (void)testFruitDoSerially {
    
    XCTAssertNotNil([[[NUFruit fruit] do] serially]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
