//
//  NUMutableDictionaryTests.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/05.
//
//

#import <XCTest/XCTest.h>
#import "NUMutableDictionary.h"

@interface NUMutableDictionaryTests : XCTestCase

@end

@implementation NUMutableDictionaryTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetAndGetAndRemove
{
    NSString *aKey = [@"Key" mutableCopy];
    NSString *anObject = [@"Object" mutableCopy];
    NUMutableDictionary *aDictionary = [NUMutableDictionary dictionary];
    [aDictionary setObject:anObject forKey:aKey];
    XCTAssertEqualObjects(anObject, [aDictionary objectForKey:aKey], @"");
    XCTAssertTrue([[aDictionary setKeys] containsObject:aKey], @"");
    [aDictionary removeObjectForKey:aKey];
    XCTAssertNil([aDictionary objectForKey:aKey], @"");
    XCTAssertTrue([[aDictionary setKeys] count] == 0, @"");
    XCTAssertTrue([[aDictionary removedKeys] containsObject:aKey], @"");
}

- (void)testNSMutableDictionary
{
    NSMutableDictionary *aDictionary = [NSMutableDictionary dictionary];
    id aKey = [@"Key" mutableCopy];
    id anObject1 = [@"anObject1" mutableCopy];
    id anObject2 = [@"anObject2" mutableCopy];
    [aDictionary setObject:anObject1 forKey:aKey];
    [aDictionary setObject:anObject2 forKey:aKey];
    XCTAssertEqualObjects(anObject2, [aDictionary objectForKey:aKey], @"");
}

- (void)testNSMutableSet
{
    NSMutableSet *aSet = [NSMutableSet set];
    id anObject1 = [@"anObject1" mutableCopy];
    id anObject1Copy = [anObject1 mutableCopy];
    XCTAssertNotEqual(anObject1, anObject1Copy, @"");
    [aSet addObject:anObject1];
    [aSet addObject:anObject1Copy];
    XCTAssertTrue([aSet count] == 1, @"");
    XCTAssertEqual(anObject1Copy, anObject1Copy, @"");
}
@end
