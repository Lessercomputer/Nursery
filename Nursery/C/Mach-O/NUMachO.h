//
//  NUMachO.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NUMachOHeader64;
@class NUMachOLoadCommand;
@class NUMachOSegmentData;
@class NSMutableArray;
@class NSData, NSMutableData;

@interface NUMachO : NSObject

+ (instancetype)exampleReturnZero;

@property (class, nonatomic) uint32_t pageSize;
@property (class, nonatomic, copy) NSString *codesignPath;
@property (nonatomic, readonly) uint32_t pageSize;
@property (nonatomic, retain) NUMachOHeader64 *header;
@property (nonatomic, retain) NSMutableArray *loadCommands;
@property (nonatomic, retain) NSMutableArray *segmentData;

@property (nonatomic, readonly) uint32_t commandCount;
@property (nonatomic, readonly) uint32_t commandSize;

@property (nonatomic) uint64_t fileSize;

- (uint64_t)roundUpToPageSize:(uint64_t)aSize;
- (uint32_t)headerAndAllLoadCommandsSize;

- (void)add:(NUMachOLoadCommand *)aLoadCommand;
- (void)computeLayout;
- (void)writeToData:(NSMutableData *)aData;
- (BOOL)writeToPath:(NSString *)aFilepath;

@end

