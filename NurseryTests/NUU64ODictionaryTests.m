//
//  NUU64ODictionaryTests.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/05.
//
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "NUTypes.h"
#import "NUU64ODictionary.h"

@interface NUU64ODictionaryTests : XCTestCase

@end

@implementation NUU64ODictionaryTests

static const NUUInt64 entryCount = 10000000;
static NSArray *numbers;

- (void)setUp
{
    [super setUp];
    
    NSMutableSet *anEntrySet = [NSMutableSet set];
    NSArray *anEntries = [NSMutableArray array];
    while ([anEntrySet count] < entryCount)
    {
        [anEntrySet addObject:[NSNumber numberWithUnsignedLongLong:random()]];
    }
    anEntries = [anEntrySet allObjects];
    numbers = [anEntries retain];
}

- (void)tearDown
{
    [numbers release];
    numbers = nil;
    
    [super tearDown];
}

- (void)testSetAndRemoveOneEntry
{
    NUU64ODictionary *aDic = [NUU64ODictionary dictionary];
    XCTAssertTrue([aDic count] == 0, @"");
    NSNumber *aSetNum0 = [NSNumber numberWithUnsignedLongLong:0];
    [aDic setObject:aSetNum0 forKey:0];
    XCTAssertTrue([aDic count] == 1, @"");
    NSNumber *aGetNum0 = [aDic objectForKey:0];
    XCTAssertEqualObjects(aSetNum0, aGetNum0, @"");
    [aDic removeObjectForKey:0];
    XCTAssertTrue([aDic count] == 0, @"");
}

- (void)testSetManyEntries
{
    NUU64ODictionary *aDic = [NUU64ODictionary dictionary];
    XCTAssertTrue([aDic count] == 0, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        NSNumber *aNum = [numbers objectAtIndex:i];
        [aDic setObject:aNum forKey:[aNum unsignedLongLongValue]];
    }
    XCTAssertTrue([aDic count] == entryCount, @"");
}

- (void)testSetAndGetManyEntries
{
    NUU64ODictionary *aDic = [NUU64ODictionary dictionary];
    XCTAssertTrue([aDic count] == 0, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        NSNumber *aNum = [numbers objectAtIndex:i];
        [aDic setObject:aNum forKey:[aNum unsignedLongLongValue]];
    }
    XCTAssertTrue([aDic count] == entryCount, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        [aDic objectForKey:i];
    }
}

- (void)testSetAndRemoveManyEntries
{
    [self measureBlock:^{
        NUU64ODictionary *aDic = [NUU64ODictionary dictionary];
        XCTAssertTrue([aDic count] == 0, @"");
        for (NUUInt64 i = 0; i < entryCount; i++)
        {
            NSNumber *aNum = [numbers objectAtIndex:i];
            [aDic setObject:aNum forKey:[aNum unsignedLongLongValue]];
        }
        XCTAssertTrue([aDic count] == entryCount, @"");
        for (NUUInt64 i = 0; i < entryCount; i++)
        {
            NSNumber *aSetNum = [numbers objectAtIndex:i];
            NSNumber *aGetNum = [aDic objectForKey:[aSetNum unsignedLongLongValue]];
            XCTAssertEqualObjects(aSetNum, aGetNum, @"");
        }
        NSEnumerator *anEnumerator = [aDic objectEnumerator];
        NSNumber *anEachNum;
        NUUInt64 aCount = 0;
        while (anEachNum = [anEnumerator nextObject])
        {
            aCount++;
        }
        XCTAssertTrue(aCount == entryCount, @"");
        for (NUUInt64 i = 0; i < entryCount; i++)
        {
            NSNumber *aNum = [numbers objectAtIndex:i];
            XCTAssertTrue([aDic count] == entryCount - i, @"");
            [aDic removeObjectForKey:[aNum unsignedLongLongValue]];
            XCTAssertTrue([aDic count] == entryCount - i - 1, @"");
        }
    }];
}

- (void)testSetAndRemoveManyEntriesWithNSDictionary
{
    NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
    XCTAssertTrue([aDic count] == 0, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        NSNumber *aNum = [numbers objectAtIndex:i];
        [aDic setObject:aNum forKey:aNum];
        [aNum unsignedLongLongValue];
    }
    XCTAssertTrue([aDic count] == entryCount, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        NSNumber *aSetNum = [numbers objectAtIndex:i];
        NSNumber *aGetNum = [aDic objectForKey:aSetNum];
        [aSetNum unsignedLongLongValue];
        XCTAssertEqualObjects(aSetNum, aGetNum, @"");
    }
    NSEnumerator *anEnumerator = [aDic objectEnumerator];
    NSNumber *anEachNum;
    NUUInt64 aCount = 0;
    while (anEachNum = [anEnumerator nextObject])
    {
        aCount++;
    }
    XCTAssertTrue(aCount == entryCount, @"");
    for (NUUInt64 i = 0; i < entryCount; i++)
    {
        NSNumber *aNum = [numbers objectAtIndex:i];
        XCTAssertTrue([aDic count] == entryCount - i, @"");
        [aDic removeObjectForKey:aNum];
        [aNum unsignedLongLongValue];
        XCTAssertTrue([aDic count] == entryCount - i - 1, @"");
    }
}

@end
