//
//  NUMachOSegmentData.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSegmentData.h"
#import "NUMachOSectionData.h"
#import "NUMachOSegmentCommand64.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSString.h>

@implementation NUMachOSegmentData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sectionData = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_sectionData release];
    [super dealloc];
}

- (void)add:(NUMachOSectionData *)aSectionData
{
    [[self sectionData] addObject:aSectionData];
}

- (void)computeLayout
{
    
}

- (uint64_t)size
{
    __block uint64_t aSize = 0;
    [[self sectionData] enumerateObjectsUsingBlock:^(NUMachOSectionData * _Nonnull aSectionData, NSUInteger idx, BOOL * _Nonnull stop) {
        aSize += [aSectionData size];
    }];
    return aSize;
}

- (void)writeToData:(NSMutableData *)aData
{
//    [aData increaseLengthBy:[[self segmentCommand] paddingSize]];
    
//    NSMutableData *aPaddingData = [NSMutableData data];
//    uint32_t aNumber = 1;
//    while ([aPaddingData length] < [[self segmentCommand] paddingSize]) {
//        [aPaddingData appendBytes:&aNumber length:sizeof(aNumber)];
//        aNumber++;
//    }
//    [aPaddingData setLength:[[self segmentCommand] paddingSize]];
//    
//    [aPaddingData writeToFile:[@"~/Desktop/pad2" stringByExpandingTildeInPath] atomically:YES];
//    [aData appendData:aPaddingData];
    if ([[self segmentCommand] isPageZero])
        return;
    
    if ([[self sectionData] count])
        [[self sectionData] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
    else
    {
        [aData increaseLengthBy:[[self segmentCommand] filesize]];
    }
}

@end
