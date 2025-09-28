//
//  NUMachODataSection.h
//  Nursery
//
//  Created by akiha on 2025/09/24.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSection.h"


@interface NUMachODataSection : NUMachOSection

@property (nonatomic, readonly) uint64_t dataOffsetInSection;

- (uint64_t)addUInt64:(uint64_t)aValue;
- (uint64_t)addInt64:(int64_t)aValue;

@end

