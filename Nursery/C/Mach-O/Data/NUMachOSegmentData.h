//
//  NUMachOSegmentData.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NUMachOSegmentCommand64;
@class NUMachOSectionData;
@class NSMutableArray;
@class NSMutableData;

@interface NUMachOSegmentData : NSObject

@property (nonatomic, assign) NUMachOSegmentCommand64 *segmentCommand;
@property (nonatomic, retain) NSMutableArray *sectionData;

- (void)add:(NUMachOSectionData *)aSectionData;
- (void)computeLayout;

@property (nonatomic, readonly) uint64_t size;

- (void)writeToData:(NSMutableData *)aData;

@end

