//
//  NUCTests.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/19.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NUCTranslationEnvironment.h"
#import "NUCSourceFile.h"

@interface NUCTests : XCTestCase

@end

@implementation NUCTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTranslationPhase1to2
{
    NSBundle *aBundle = [NSBundle bundleForClass:[self class]];
    NSURL *aPhysicalSourceFileURL = [aBundle URLForResource:@"CTranslationPhase1to2Example" withExtension:NULL subdirectory:NULL];
    NSURL *anExpectedLogicalSourceFileURL = [aBundle URLForResource:@"ExpectedCTranslationPhase1to2Example" withExtension:NULL subdirectory:NULL];

    NUCTranslationEnvironment *aCTranslationEnvironment = [[[NUCTranslationEnvironment alloc] initWithSourceFileURLs:[NSArray arrayWithObject:aPhysicalSourceFileURL]] autorelease];
    NUCSourceFile *aSourceFile = nil;
    NSString *anExpectedLogicalSourceString = [NSString stringWithContentsOfURL:anExpectedLogicalSourceFileURL usedEncoding:NULL error:NULL];
    
    [aCTranslationEnvironment translate];
    
    aSourceFile = [[aCTranslationEnvironment sourceFiles] firstObject];
    XCTAssertEqualObjects([aSourceFile logicalSourceString], anExpectedLogicalSourceString);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
