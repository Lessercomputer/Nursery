//
//  NUMachOSegment.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NUMachOSection;
@class NSMutableArray;

@interface NUMachOSegment : NSObject

@property (nonatomic, retain) NSMutableArray *sections;
 
- (void)add:(NUMachOSection *)aSection;

@end

