//
//  NULinkedListTest.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/07/23.
//

#import <XCTest/XCTest.h>
#import "NULinkedList.h"
#import "NULinkedListElement.h"

@interface NULinkedListTest : XCTestCase

@end

@implementation NULinkedListTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmptyLinkedList
{
    NULinkedList *aLinkedList = [[NULinkedList new] autorelease];
    XCTAssertEqual([aLinkedList count], 0);
    XCTAssertEqualObjects([aLinkedList first], nil);
    XCTAssertEqualObjects([aLinkedList last], nil);
}

- (void)testAddOneElement
{
    NULinkedList *aLinkedList = [[NULinkedList new] autorelease];
    NULinkedListElement *anElement = [NULinkedListElement listElementWithObject:@(0)];
    [aLinkedList addElementAtFirst:anElement];
    
    XCTAssertTrue([aLinkedList count] == 1);
    XCTAssertTrue([aLinkedList contains:anElement]);
    
    XCTAssertEqualObjects([aLinkedList first], anElement);
    XCTAssertEqualObjects([aLinkedList last], anElement);
    
    XCTAssertEqualObjects([[aLinkedList first] previous], nil);
    XCTAssertEqualObjects([[aLinkedList first] next], nil);
}

- (void)testAddOneElementAndRemoveLast
{
    NULinkedList *aLinkedList = [[NULinkedList new] autorelease];
    NULinkedListElement *anElement = [NULinkedListElement listElementWithObject:@(0)];
    [aLinkedList addElementAtFirst:anElement];
    
    XCTAssertTrue([aLinkedList count] == 1);
    
    XCTAssertTrue([aLinkedList contains:anElement]);
    
    [aLinkedList removeLast];
    
    XCTAssertTrue([aLinkedList count] == 0);
    XCTAssertFalse([aLinkedList contains:anElement]);
    
    XCTAssertEqualObjects([aLinkedList first], nil);
    XCTAssertEqualObjects([aLinkedList last], nil);
}

- (void)testAddThreeElement
{
    NULinkedList *aLinkedList = [[NULinkedList new] autorelease];
    NULinkedListElement *anElement0 = [NULinkedListElement listElementWithObject:@(0)];
    NULinkedListElement *anElement1 = [NULinkedListElement listElementWithObject:@(1)];
    NULinkedListElement *anElement2 = [NULinkedListElement listElementWithObject:@(2)];
    [aLinkedList addElementAtFirst:anElement0];
    [aLinkedList addElementAtFirst:anElement1];
    [aLinkedList addElementAtFirst:anElement2];
    
    XCTAssertTrue([aLinkedList count] == 3);
    
    XCTAssertTrue([aLinkedList contains:anElement0]);
    XCTAssertTrue([aLinkedList contains:anElement1]);
    XCTAssertTrue([aLinkedList contains:anElement2]);
    
    XCTAssertEqualObjects([aLinkedList first], anElement2);
    XCTAssertEqualObjects([aLinkedList last], anElement0);
    
    XCTAssertEqualObjects([[aLinkedList first] previous], nil);
    XCTAssertEqualObjects([[aLinkedList first] next], anElement1);
    XCTAssertEqualObjects([[[aLinkedList first] next] next], anElement0);
    
    XCTAssertEqualObjects([[aLinkedList last] next], nil);
    XCTAssertEqualObjects([[aLinkedList last] previous], anElement1);
    XCTAssertEqualObjects([[[aLinkedList last] previous] previous], anElement2);
}

- (void)testAddThreeElementAndRemoveLastElement
{
    NULinkedList *aLinkedList = [[NULinkedList new] autorelease];
    NULinkedListElement *anElement0 = [NULinkedListElement listElementWithObject:@(0)];
    NULinkedListElement *anElement1 = [NULinkedListElement listElementWithObject:@(1)];
    NULinkedListElement *anElement2 = [NULinkedListElement listElementWithObject:@(2)];
    [aLinkedList addElementAtFirst:anElement0];
    [aLinkedList addElementAtFirst:anElement1];
    [aLinkedList addElementAtFirst:anElement2];
    
    XCTAssertTrue([aLinkedList count] == 3);
    
    [aLinkedList removeLast];
    
    XCTAssertTrue([aLinkedList count] == 2);
    XCTAssertFalse([aLinkedList contains:anElement0]);
    
    XCTAssertEqualObjects([aLinkedList first], anElement2);
    XCTAssertEqualObjects([aLinkedList last], anElement1);
    
    XCTAssertEqualObjects([[aLinkedList first] previous], nil);
    XCTAssertEqualObjects([[aLinkedList first] next], anElement1);
    
    XCTAssertEqualObjects([[aLinkedList last] next], nil);
    XCTAssertEqualObjects([[aLinkedList last] previous], anElement2);
}

- (void)testAddThreeElementAndRemoveMiddleElement
{
    NULinkedList *aLinkedList = [[NULinkedList new] autorelease];
    NULinkedListElement *anElement0 = [NULinkedListElement listElementWithObject:@(0)];
    NULinkedListElement *anElement1 = [NULinkedListElement listElementWithObject:@(1)];
    NULinkedListElement *anElement2 = [NULinkedListElement listElementWithObject:@(2)];
    [aLinkedList addElementAtFirst:anElement0];
    [aLinkedList addElementAtFirst:anElement1];
    [aLinkedList addElementAtFirst:anElement2];
    [aLinkedList remove:anElement1];
    
    XCTAssertTrue([aLinkedList count] == 2);
    XCTAssertFalse([aLinkedList contains:anElement1]);
    
    XCTAssertEqualObjects([aLinkedList first], anElement2);
    XCTAssertEqualObjects([aLinkedList last], anElement0);
    
    XCTAssertEqualObjects([[aLinkedList first] previous], nil);
    XCTAssertEqualObjects([[aLinkedList first] next], anElement0);
    
    XCTAssertEqualObjects([[aLinkedList last] next], nil);
    XCTAssertEqualObjects([[aLinkedList last] previous], anElement2);
}

- (void)testAddThreeElementAndRemoveFirstElement
{
    NULinkedList *aLinkedList = [[NULinkedList new] autorelease];
    NULinkedListElement *anElement0 = [NULinkedListElement listElementWithObject:@(0)];
    NULinkedListElement *anElement1 = [NULinkedListElement listElementWithObject:@(1)];
    NULinkedListElement *anElement2 = [NULinkedListElement listElementWithObject:@(2)];
    [aLinkedList addElementAtFirst:anElement0];
    [aLinkedList addElementAtFirst:anElement1];
    [aLinkedList addElementAtFirst:anElement2];
    [aLinkedList remove:[aLinkedList first]];
    
    XCTAssertTrue([aLinkedList count] == 2);
    XCTAssertFalse([aLinkedList contains:anElement2]);
    
    XCTAssertEqualObjects([aLinkedList first], anElement1);
    XCTAssertEqualObjects([aLinkedList last], anElement0);
    
    XCTAssertEqualObjects([[aLinkedList first] previous], nil);
    XCTAssertEqualObjects([[aLinkedList first] next], anElement0);
    
    XCTAssertEqualObjects([[aLinkedList last] next], nil);
    XCTAssertEqualObjects([[aLinkedList last] previous], anElement1);
}

- (void)testMoveToFirst
{
    NULinkedList *aLinkedList = [[NULinkedList new] autorelease];
    NULinkedListElement *anElement0 = [NULinkedListElement listElementWithObject:@(0)];
    NULinkedListElement *anElement1 = [NULinkedListElement listElementWithObject:@(1)];
    NULinkedListElement *anElement2 = [NULinkedListElement listElementWithObject:@(2)];
    [aLinkedList addElementAtFirst:anElement0];
    [aLinkedList addElementAtFirst:anElement1];
    [aLinkedList addElementAtFirst:anElement2];
    
    [aLinkedList moveToFirst:anElement1];
    
    XCTAssertTrue([aLinkedList count] == 3);
    
    XCTAssertEqualObjects([aLinkedList first], anElement1);
    XCTAssertEqualObjects([[aLinkedList first] previous], nil);
    XCTAssertEqualObjects([[aLinkedList first] next], anElement2);
    XCTAssertEqualObjects([[[aLinkedList first] next] next], anElement0);
    
    XCTAssertEqualObjects([aLinkedList last], anElement0);
    XCTAssertEqualObjects([[aLinkedList last] next], nil);
    XCTAssertEqualObjects([[aLinkedList last] previous], anElement2);
    XCTAssertEqualObjects([[[aLinkedList last] previous] previous], anElement1);
    
    [aLinkedList moveToFirst:anElement0];
    
    XCTAssertTrue([aLinkedList count] == 3);
    
    XCTAssertEqualObjects([aLinkedList first], anElement0);
    XCTAssertEqualObjects([[aLinkedList first] previous], nil);
    XCTAssertEqualObjects([[aLinkedList first] next], anElement1);
    XCTAssertEqualObjects([[[aLinkedList first] next] next], anElement2);
    
    XCTAssertEqualObjects([aLinkedList last], anElement2);
    XCTAssertEqualObjects([[aLinkedList last] next], nil);
    XCTAssertEqualObjects([[aLinkedList last] previous], anElement1);
    XCTAssertEqualObjects([[[aLinkedList last] previous] previous], anElement0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
