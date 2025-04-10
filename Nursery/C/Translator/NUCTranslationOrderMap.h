//
//  NUCTranslationMap.h
//  Nursery
//
//  Created by akiha on 2025/04/10.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <Nursery/NUTypes.h>

@class NSMutableArray, NSMutableDictionary;

@interface NUCTranslationOrderMap : NSObject

@property (nonatomic, readonly) NSMutableDictionary *mappingDictionary;
@property (nonatomic, readonly) NSMutableArray *mappingArray;
@property (nonatomic, readonly) NUUInt64 depth;

- (void)add:(id)aNode parent:(id)aParent depth:(NUUInt64)aDepth;
- (NSMutableArray *)siblingsFor:(id)aParent depth:(NUUInt64)aDepth;

@end

