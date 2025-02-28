//
//  NUMachOLoadCommand.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <mach-o/loader.h>

@interface NUMachOLoadCommand : NSObject

@property (nonatomic, readonly) uint32_t size;
@property (nonatomic, retain) NSData *serializedData;

@end

