//
//  NULibraryTests.m
//  Nursery
//
//  Created by P,T,A on 2013/02/09.
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
    NUNurseryTestFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"nursery.nu"];
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
