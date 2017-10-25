//
//  NUBellBallODictionaryTests.m
//  Nursery
//
//  Created by P,T,A on 2014/02/16.
//
//

#import <XCTest/XCTest.h>
#import <Nursery/Nursery.h>

static const NUUInt64 entryCount = 1000000;
static NSArray *bells;

@interface NUBellBallODictionaryTests : XCTestCase

@end

@implementation NUBellBallODictionaryTests

- (void)setUp
{
    [super setUp];
    NSMutableSet *anEntrySet = [NSMutableSet set];
    NSArray *anEntries = [NSMutableArray array];
    while ([anEntrySet count] < entryCount)
    {
        NUBellBall aBellBall = NUMakeBellBall(random(), random());
        [anEntrySet addObject:[NSValue valueWithBytes:&aBellBall objCType:@encode(NUBellBall)]];
    }
    anEntries = [anEntrySet allObjects];
    bells = [anEntries retain];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetAndRemoveManyEntries
{
    NUBellBallODictionary *aDic = [NUBellBallODictionary dictionary];
    XCTAssertTrue([aDic count] == 0, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        NSValue *aVal = [bells objectAtIndex:i];
        NUBellBall aBellBall;
        [aVal getValue:&aBellBall];
        [aDic setObject:aVal forKey:aBellBall];
    }
    XCTAssertTrue([aDic count] == entryCount, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        NSValue *aSetVal = [bells objectAtIndex:i];
        NUBellBall aBellBall;
        [aSetVal getValue:&aBellBall];
        NSValue *aGetVal = [aDic objectForKey:aBellBall];
        XCTAssertEqualObjects(aSetVal, aGetVal, @"");
    }
    NSEnumerator *anEnumerator = [aDic objectEnumerator];
    NSValue *anEachVal;
    NUUInt64 aCount = 0;
    while (anEachVal = [anEnumerator nextObject])
    {
        aCount++;
    }
    XCTAssertTrue(aCount == entryCount, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        NSNumber *aVal = [bells objectAtIndex:i];
        XCTAssertTrue([aDic count] == entryCount - i, @"");
        NUBellBall aBellBall;
        [aVal getValue:&aBellBall];
        [aDic removeObjectForKey:aBellBall];
        XCTAssertTrue([aDic count] == entryCount - i - 1, @"");
    }
}

@end
