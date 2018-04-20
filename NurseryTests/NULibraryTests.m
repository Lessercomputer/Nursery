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

- (NULibrary *)libraryWithKeyFrom:(NSNumber *)aKey1 to:(NSNumber *)aKey2
{
    NULibrary *aLibrary = [NULibrary library];
    
    for (NSInteger i = [aKey1 integerValue]; i <= [aKey2 integerValue]; i++)
         [aLibrary setObject:@(i) forKey:@(i)];
    
    return aLibrary;
}

- (void)testFirstKey
{
    NULibrary *aLibrary = [NULibrary library];
    XCTAssertNil([aLibrary firstKey]);
    
    aLibrary = [self libraryWithKeyFrom:@(0) to:@(100000)];
    XCTAssertEqual([[aLibrary firstKey] integerValue], 0);
}

- (void)testLastKey
{
    NULibrary *aLibrary = [NULibrary library];
    XCTAssertNil([aLibrary lastKey]);
    
    aLibrary = [self libraryWithKeyFrom:@(0) to:@(100000)];
    XCTAssertEqual([[aLibrary lastKey] integerValue], 100000);
}


- (void)testKeyGreaterThanOrEqual
{
    NULibrary *aLibrary = [NULibrary library];
    XCTAssertNil([aLibrary keyGreaterThanOrEqualTo:@(0)]);
    
    aLibrary = [self libraryWithKeyFrom:@(0) to:@(100000)];
    XCTAssertGreaterThanOrEqual([[aLibrary keyGreaterThanOrEqualTo:@(50000)] integerValue], 50000);
    XCTAssertGreaterThanOrEqual([[aLibrary keyGreaterThanOrEqualTo:@(-1)] integerValue], -1);
    XCTAssertNil([aLibrary keyGreaterThanOrEqualTo:@(100001)]);
}

- (void)testKeyGreaterThan
{
    NULibrary *aLibrary = [NULibrary library];
    XCTAssertNil([aLibrary keyGreaterThan:@(0)]);
    
    aLibrary = [self libraryWithKeyFrom:@(0) to:@(100000)];
    XCTAssertGreaterThan([[aLibrary keyGreaterThan:@(50000)] integerValue], 50000);
    XCTAssertGreaterThan([[aLibrary keyGreaterThan:@(-1)] integerValue], -1);
    XCTAssertNil([aLibrary keyGreaterThan:@(100001)]);
}

- (void)testKeyLessThanOrEqual
{
    NULibrary *aLibrary = [NULibrary library];
    XCTAssertNil([aLibrary keyLessThanOrEqualTo:@(0)]);
    
    aLibrary = [self libraryWithKeyFrom:@(0) to:@(100000)];
    XCTAssertLessThanOrEqual([[aLibrary keyLessThanOrEqualTo:@(50000)] integerValue], 50000);
    XCTAssertLessThanOrEqual([[aLibrary keyLessThanOrEqualTo:@(100001)] integerValue], 100001);
    XCTAssertNil([aLibrary keyLessThanOrEqualTo:@(-1)]);
}

- (void)testKeyLessThan
{
    NULibrary *aLibrary = [NULibrary library];
    XCTAssertNil([aLibrary keyLessThan:@(0)]);
    
    aLibrary = [self libraryWithKeyFrom:@(0) to:@(100000)];
    XCTAssertLessThan([[aLibrary keyLessThan:@(50000)] integerValue], 50000);
    XCTAssertLessThan([[aLibrary keyLessThan:@(100001)] integerValue], 100001);
    XCTAssertNil([aLibrary keyLessThan:@(-1)]);
}

- (void)enumerateWithKeyGreaterThan:(NSNumber *)aKey1 orEqual:(BOOL)anOrEqualFlag1 andLessThan:(NSNumber *)aKey2 orEqual:(BOOL)anOrEqualFlag2 reverse:(BOOL)aReverseFlag onLibraryWithKeyFrom:(NSNumber *)aKeyFrom to:(NSNumber *)aKeyTo
{
    NULibrary *aLibrary = [self libraryWithKeyFrom:aKeyFrom to:aKeyTo];
    __block NSInteger aCurrentKey = !aReverseFlag ? [aKeyFrom integerValue] - 1 : [aKeyTo integerValue] + 1;
    __block BOOL aKeyIsFirst = NO;
    NSEnumerationOptions anOpts = !aReverseFlag ? 0 : NSEnumerationReverse;
    
    [aLibrary enumerateKeysAndObjectsWithKeyGreaterThan:aKey1 orEqual:anOrEqualFlag1 andKeyLessThan:aKey2 orEqual:anOrEqualFlag2 options:anOpts usingBlock:^(id aKey, id anObj, BOOL *aStop) {
        
//        NSLog(@"aKey:%@",aKey);
        
        if (!aKeyIsFirst)
        {
            aKeyIsFirst = YES;
            
            if (!aReverseFlag && aKey1)
            {
                if (anOrEqualFlag1)
                    XCTAssertGreaterThanOrEqual([aKey integerValue], [aKey1 integerValue]);
                else
                    XCTAssertGreaterThan([aKey integerValue], [aKey1 integerValue]);
            }
            
            if (aReverseFlag && aKey2)
            {
                if (anOrEqualFlag2)
                    XCTAssertLessThanOrEqual([aKey integerValue], [aKey2 integerValue]);
                else
                    XCTAssertLessThan([aKey integerValue], [aKey2 integerValue]);
            }
        }
        
        if (aKey1)
        {
            if (anOrEqualFlag1)
                XCTAssertGreaterThanOrEqual([aKey integerValue], [aKey1 integerValue]);
            else
                XCTAssertGreaterThan([aKey integerValue], [aKey1 integerValue]);
        }
        
        if (aKey2)
        {
            if (anOrEqualFlag2)
                XCTAssertLessThanOrEqual([aKey integerValue], [aKey2 integerValue]);
            else
                XCTAssertLessThan([aKey integerValue], [aKey2 integerValue]);
        }
        
        if (!aReverseFlag)
            XCTAssertGreaterThan([aKey integerValue], aCurrentKey);
        else
            XCTAssertLessThan([aKey integerValue], aCurrentKey);
        
        aCurrentKey = [aKey integerValue];
    }];
}

- (void)testEnumerateWithNotExistingKey
{
    [self enumerateWithKeyGreaterThan:@(-1) orEqual:YES andLessThan:@(100001) orEqual:YES reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testEnumerateWithKeyGreaterThanOrEqualAndKeyLessThanOrEqual
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:YES andLessThan:@(40000) orEqual:YES reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testEnumerateWithKeyGreaterThanOrEqualAndLessThan
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:YES andLessThan:@(40000) orEqual:NO reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testEnumerateWithKeyGreaterThanAndLessThanOrEqual
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:NO andLessThan:@(40000) orEqual:YES reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testEnumerateWithKeyGreaterThanAndLessThan
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:NO andLessThan:@(40000) orEqual:NO reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testEnumerateWithKeyGreaterThanOrEqual
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:YES andLessThan:nil orEqual:YES reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testEnumerateWithKeyGreaterThan
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:NO andLessThan:nil orEqual:YES reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testEnumerateWithKeyLessThanOrEqual
{
    [self enumerateWithKeyGreaterThan:nil orEqual:YES andLessThan:@(40000) orEqual:YES reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testEnumerateWithKeyLessThan
{
    [self enumerateWithKeyGreaterThan:nil orEqual:YES andLessThan:@(40000) orEqual:NO reverse:NO onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithNotExistingKey
{
    [self enumerateWithKeyGreaterThan:@(-1) orEqual:YES andLessThan:@(100001) orEqual:YES reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithKeyGreaterThanOrEqualAndKeyLessThanOrEqual
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:YES andLessThan:@(40000) orEqual:YES reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithKeyGreaterThanOrEqualAndLessThan
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:YES andLessThan:@(40000) orEqual:NO reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithKeyGreaterThanAndLessThanOrEqual
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:NO andLessThan:@(40000) orEqual:YES reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithKeyGreaterThanAndLessThan
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:NO andLessThan:@(40000) orEqual:NO reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithKeyGreaterThanOrEqual
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:YES andLessThan:nil orEqual:YES reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithKeyGreaterThan
{
    [self enumerateWithKeyGreaterThan:@(30000) orEqual:NO andLessThan:nil orEqual:YES reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithKeyLessThanOrEqual
{
    [self enumerateWithKeyGreaterThan:nil orEqual:YES andLessThan:@(40000) orEqual:YES reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testReverseEnumerateWithKeyLessThan
{
    [self enumerateWithKeyGreaterThan:nil orEqual:YES andLessThan:@(40000) orEqual:NO reverse:YES onLibraryWithKeyFrom:@(0) to:@(100000)];
}

- (void)testSaveAndLoadLibrary
{
    NSArray *aNumbers = nil;

    @autoreleasepool
    {
        NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
        NUGarden *aGarden = [aNursery makeGarden];
        
        const NUUInt64 MaxCount = 10000;
        NULibrary *aLibrary = [NULibrary library];
        NSMutableSet *aNumberSet = [NSMutableSet set];
        for (int i = 0; i < MaxCount; i++)
            [aNumberSet addObject:[NSNumber numberWithUnsignedLongLong:random()]];
        aNumbers = [[aNumberSet allObjects] retain];
        
        [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [aLibrary setObject:obj forKey:obj];
        }];

        [aGarden setRoot:aLibrary];
        XCTAssertEqual([aGarden farmOut], NUFarmOutStatusSucceeded, @"");
    }
    
    [aNumbers autorelease];
    
    NUNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:NUNurseryTestFilePath];
    NUGarden *aGarden = [aNursery makeGarden];
    NULibrary *aLoadedLibrary = [aGarden root];
    
    XCTAssertEqual((NUUInt64)[aLoadedLibrary count], [aNumbers count], @"");
    [aNumbers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqualObjects([aLoadedLibrary objectForKey:obj], obj, @"");
    }];
}

@end
