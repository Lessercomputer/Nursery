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
@class NUMachOData;
@class NSMutableArray;
@class NSData;

@interface NUMachO : NSObject

@property (nonatomic, retain) NUMachOHeader64 *header;
@property (nonatomic, retain) NSMutableArray *loadCommands;
@property (nonatomic, retain) NUMachOData *data;

- (void)add:(NUMachOLoadCommand *)aLoadCommand;

@property (nonatomic, readonly) uint32_t commandCount;
@property (nonatomic, readonly) uint32_t commandSize;
@property (nonatomic, readonly) NSData *serializedBinaryData;

- (BOOL)writeToPath:(NSString *)aFilepath;

@end

