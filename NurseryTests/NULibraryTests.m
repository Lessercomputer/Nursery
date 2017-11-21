//
//  NULibraryTests.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/02/09.
//
//

#import <XCTest/XCTest.h>
#import <Nursery/Nursery.h>

static NSString *NUNurseryTestFilePath = nil;

@interface NULibraryTests : XCTestCase

@end

@implementation NULibraryTests

- (void)setUp
{
    [super setUp];
    NUNurseryTestFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"nursery.nursery"];
	[[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];
}

- (void)tearDown
{
	[[NSFileManager defaultManager] removeItemAtPath:NUNurseryTestFilePath error:nil];
    [super tearDown];
}

- (void)testSetAndGetObjet
{
    NULibrary *aLibrary = [NULibrary library];
    NSNumber *aNumber = [NSNumber numberWithUnsignedLongLong:0];
    
    [aLibrary setObject:aNumber forKey:aNumber];
    XCTAssertEqual((NUUInt64)1, [aLibrary count], @"");
    XCTAssertEqualObjects([aLibrary objectForKey:aNumber], aNumber, @"");
}

- (void)testSetAndRemoveObject
{
    NULibrary *aLibrary = [NULibrary library];
    NSNumber *aNumber = [NSNumber numberWithUnsignedLongLong:0];
    
    [aLibrary setObject:aNumber forKey:aNumber];
    [aLibrary removeObjectForKey:aNumber];
    XCTAssertEqual((NUUInt64)0, [aLibrary count], @"");
    XCTAssertEqualObjects([aLibrary objectForKey:aNumber], nil, @"");
}

- (void)testSetAndGetObjects
{
    const int MaxCount = 1000000;
    NULibrary *aLibrary = [NULibrary library];
    NSMutableSet *aNumberSet = [NSMutableSet set];
    NSArray *aNumbers;
    for (int i = 0; i < MaxCount; i++)
        [aNumberSet addObject:[NSNumber numberWithUnsignedLongLong:random()]];
    aNumbers = [aNumberSet allObjects];
    
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aLibrary setObject:obj forKey:obj];
    }];
    XCTAssertEqual((NUUInt64)[aNumbers count], [aLibrary count], @"");
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqual([aLibrary objectForKey:obj], obj, @"");
    }];
}

- (void)testSetAndRemoveObjects
{
    const int MaxCount = 1000000;
    NULibrary *aLibrary = [NULibrary library];
    NSMutableSet *aNumberSet = [NSMutableSet set];
    NSArray *aNumbers;
    for (int i = 0; i < MaxCount; i++)
        [aNumberSet addObject:[NSNumber numberWithUnsignedLongLong:random()]];
    aNumbers = [aNumberSet allObjects];
    
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aLibrary setObject:obj forKey:obj];
    }];
    __block NUUInt64 aCount = [aLibrary count];
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        /*if (![[aLibrary objectForKey:obj] isEqual:obj])
        {
            NSLog(@"error");
            NSEnumerator *enumerator = [aLibrary objectEnumerator];
            NSNumber *aNumber = nil;
            while (aNumber = [enumerator nextObject])
            {
                if ([[aLibrary comparator] compareObject:aNumber toObject:obj] == NSOrderedSame/)
                    NSLog(@"found: %@", [aNumber description]);
            }
        }*/
        XCTAssertEqualObjects([aLibrary objectForKey:obj], obj, @"");
        [aLibrary removeObjectForKey:obj];
        aCount--;
        XCTAssertEqualObjects([aLibrary objectForKey:obj], nil, @"");
        XCTAssertEqual(aCount, [aLibrary count], @"");
    }];
}

- (void)testSetAndRemoveObjects2
{
    const int MaxCount = 60000;
    NULibrary *aLibrary = [NULibrary library];
    NSMutableArray *aNumbers = [NSMutableArray array];
    for (int i = 0; i < MaxCount; i++)
        [aNumbers addObject:[NSNumber numberWithUnsignedLongLong:i]];
    
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aLibrary setObject:obj forKey:obj];
    }];
    __block NUUInt64 aCount = [aLibrary count];
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        /*if (![[aLibrary objectForKey:obj] isEqual:obj])
            NSLog(@"error");*/
        XCTAssertEqualObjects([aLibrary objectForKey:obj], obj, @"");
        [aLibrary removeObjectForKey:obj];
        aCount--;
        XCTAssertEqualObjects([aLibrary objectForKey:obj], nil, @"");
        XCTAssertEqual([aLibrary count], aCount, @"");
    }];
}

- (void)testSetAndEnumerateFromTo
{
    [self setAndEnumerateFrom:@(300000) to:@(400000) max:1000000];
}

- (void)testSetAndEnumerateFrom
{
    [self setAndEnumerateFrom:@(30000) to:nil max:1000000];
}

- (void)testSetAndEnumerateTo
{
    [self setAndEnumerateFrom:nil to:@(60000) max:1000000];
}

- (void)setAndEnumerateFrom:(NSNumber *)aKeyFrom to:(NSNumber *)aKeyTo max:(NSInteger)aMaxCount
{
    NULibrary *aLibrary = [NULibrary library];
    NSMutableArray *aNumbers = [NSMutableArray array];
    
    for (int i = 0; i < aMaxCount; i++)
        [aNumbers addObject:[NSNumber numberWithInteger:i]];
    
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aLibrary setObject:obj forKey:obj];
    }];
    
    __block NSInteger aCurrentKey = 0;
    
    if (aKeyFrom && aKeyTo)
    {
        [aLibrary enumerateKeysAndObjectsFrom:aKeyFrom to:aKeyTo options:0 usingBlock:^(id aKey, id anObj, BOOL *aStop) {
            NSComparisonResult aResult1 = [[aLibrary comparator] compareObject:aKey toObject:aKeyFrom];
            NSComparisonResult aResult2 = [[aLibrary comparator] compareObject:aKey toObject:aKeyTo];
//            NSLog(@"aKey:%@",aKey);
            XCTAssertTrue((aResult1 == NSOrderedSame || aResult1 == NSOrderedDescending)
                          && (aResult2 == NSOrderedSame || aResult2 == NSOrderedAscending));
            XCTAssertGreaterThan([aKey integerValue], aCurrentKey);
            aCurrentKey = [aKey integerValue];
        }];
    }
    else if (aKeyFrom)
    {
        [aLibrary enumerateKeysAndObjectsFrom:aKeyFrom to:aKeyTo options:0 usingBlock:^(id aKey, id anObj, BOOL *aStop) {
            NSComparisonResult aResult1 = [[aLibrary comparator] compareObject:aKey toObject:aKeyFrom];
//            NSLog(@"aKey:%@",aKey);
            XCTAssertTrue(aResult1 == NSOrderedSame || aResult1 == NSOrderedDescending);
            XCTAssertGreaterThan([aKey integerValue], aCurrentKey);
            aCurrentKey = [aKey integerValue];
        }];
    }
    else
    {
        [aLibrary enumerateKeysAndObjectsFrom:aKeyFrom to:aKeyTo options:0 usingBlock:^(id aKey, id anObj, BOOL *aStop) {
            NSComparisonResult aResult2 = [[aLibrary comparator] compareObject:aKey toObject:aKeyTo];
//            NSLog(@"aKey:%@",aKey);
            XCTAssertTrue(aResult2 == NSOrderedSame || aResult2 == NSOrderedAscending);
            XCTAssertGreaterThanOrEqual([aKey integerValue], aCurrentKey);
            aCurrentKey = [aKey integerValue];
        }];
    }
}

- (void)testSetAndReverseEnumerateFromTo
{
    [self setAndReverseEnumerateFrom:@(300000) to:@(400000) max:1000000];
}

- (void)testSetAndReverseEnumerateFrom
{
    [self setAndReverseEnumerateFrom:@(30000) to:nil max:1000000];
}

- (void)testSetAndReverseEnumerateTo
{
    [self setAndReverseEnumerateFrom:nil to:@(60000) max:1000000];
}

- (void)setAndReverseEnumerateFrom:(NSNumber *)aKeyFrom to:(NSNumber *)aKeyTo max:(NSInteger)aMaxCount
{
    NULibrary *aLibrary = [NULibrary library];
    NSMutableArray *aNumbers = [NSMutableArray array];
    
    for (int i = 0; i < aMaxCount; i++)
        [aNumbers addObject:[NSNumber numberWithInteger:i]];
    
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aLibrary setObject:obj forKey:obj];
    }];
    
    __block NSInteger aCurrentKey = aKeyTo ? [aKeyTo integerValue] : aMaxCount;
    
    if (aKeyFrom && aKeyTo)
    {
        [aLibrary enumerateKeysAndObjectsFrom:aKeyFrom to:aKeyTo options:NSEnumerationReverse usingBlock:^(id aKey, id anObj, BOOL *aStop) {
            NSComparisonResult aResult1 = [[aLibrary comparator] compareObject:aKey toObject:aKeyFrom];
            NSComparisonResult aResult2 = [[aLibrary comparator] compareObject:aKey toObject:aKeyTo];
//            NSLog(@"aKey:%@",aKey);
            XCTAssertTrue((aResult1 == NSOrderedSame || aResult1 == NSOrderedDescending)
                          && (aResult2 == NSOrderedSame || aResult2 == NSOrderedAscending));
            XCTAssertLessThanOrEqual([aKey integerValue], aCurrentKey);
            aCurrentKey = [aKey integerValue];
        }];
    }
    else if (aKeyFrom)
    {
        [aLibrary enumerateKeysAndObjectsFrom:aKeyFrom to:aKeyTo options:NSEnumerationReverse usingBlock:^(id aKey, id anObj, BOOL *aStop) {
            NSComparisonResult aResult1 = [[aLibrary comparator] compareObject:aKey toObject:aKeyFrom];
//            NSLog(@"aKey:%@",aKey);
            XCTAssertTrue(aResult1 == NSOrderedSame || aResult1 == NSOrderedDescending);
            XCTAssertLessThanOrEqual([aKey integerValue], aCurrentKey);
            aCurrentKey = [aKey integerValue];
        }];
    }
    else
    {
        [aLibrary enumerateKeysAndObjectsFrom:aKeyFrom to:aKeyTo options:NSEnumerationReverse usingBlock:^(id aKey, id anObj, BOOL *aStop) {
            NSComparisonResult aResult2 = [[aLibrary comparator] compareObject:aKey toObject:aKeyTo];
//            NSLog(@"aKey:%@",aKey);
            XCTAssertTrue(aResult2 == NSOrderedSame || aResult2 == NSOrderedAscending);
            XCTAssertLessThanOrEqual([aKey integerValue], aCurrentKey);
            aCurrentKey = [aKey integerValue];
        }];
    }
}

- (void)testSaveAndLoadLibrary
{
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    
    const NUUInt64 MaxCount = 1000;
    NULibrary *aLibrary = [NULibrary library];
    NSMutableSet *aNumberSet = [NSMutableSet set];
    NSArray *aNumbers;
    for (int i = 0; i < MaxCount; i++)
        [aNumberSet addObject:[NSNumber numberWithUnsignedLongLong:random()]];
    aNumbers = [aNumberSet allObjects];
    
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aLibrary setObject:obj forKey:obj];
    }];

    [[aNursery sandbox] setRoot:aLibrary];
    XCTAssertEqual([[aNursery sandbox] farmOut], NUFarmOutStatusSucceeded, @"");
    [[aNursery sandbox] close];
    
    aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NULibrary *aLoadedLibrary = [[aNursery sandbox] root];
    
    XCTAssertEqual((NUUInt64)[aLoadedLibrary count], [aNumbers count], @"");
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqualObjects([aLoadedLibrary objectForKey:obj], obj, @"");
    }];
    
    [[aNursery sandbox] close];
}

@end
