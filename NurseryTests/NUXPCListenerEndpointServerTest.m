//
//  NUXPCListenerEndpointServerTest.m
//  NurseryTests
//
//  Created by Akifumi Takata on 2017/12/09.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NUXPCListenerEndpointServer.h"

@interface NUXPCListenerEndpointServerTest : XCTestCase

@end

@implementation NUXPCListenerEndpointServerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testServer
{
    //    XCTestExpectation *anExpection = [XCTestExpectation new];
    
    @autoreleasepool {
        NSXPCListener *aListener = [NSXPCListener anonymousListener];
        [[NUXPCListenerEndpointServer sharedInstance] registerEndpoint:[aListener endpoint] name:@"endpoint"];
        NSXPCListenerEndpoint *anEndpoint = [[NUXPCListenerEndpointServer sharedInstance] endpointForName:@"endpoint"];
        NSLog(@"%@", anEndpoint);
    }
    
    //    [self waitForExpectationsWithTimeout:10 handler:nil];
}
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    @autoreleasepool {
        [NSRunLoop currentRunLoop];
        [NUXPCListenerEndpointServer sharedInstance];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
