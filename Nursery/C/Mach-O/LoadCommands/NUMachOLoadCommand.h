//
//  NUMachOLoadCommand.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <mach-o/loader.h>

@class NUMachOHeader64;
@class NUMachOSegmentCommand64;
@class NSMutableData;

@interface NUMachOLoadCommand : NSObject

@property (nonatomic, assign) NUMachOHeader64 *header;
@property (nonatomic, assign) NUMachOLoadCommand *previous;
@property (nonatomic, readonly) NUMachOSegmentCommand64 *previousLoadSegmentCommand;
@property (nonatomic, readonly) uint32_t size;
@property (nonatomic, readonly) BOOL isSegmentCommand;

- (void)computeLayout;
- (void)computeLoadCommandSize;
- (uint32_t)roundUpLoadCommandSize:(uint32_t)aCommandSize;
- (uint64_t)roundUpToPageSize:(uint64_t)aSize;
- (void)writeToData:(NSMutableData *)aData;

@end

