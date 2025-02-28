//
//  NUMachOHeader64.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <mach-o/loader.h>

@class NUMachO;
@class NSData;

@interface NUMachOHeader64 : NSObject

@property (nonatomic, assign) NUMachO *machO;
@property (nonatomic) struct mach_header_64 machHeader;

@property (nonatomic, readonly) NSData *serializedBinaryData;

@end

