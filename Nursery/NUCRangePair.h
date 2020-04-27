//
//  NUCRangePair.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/27.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

#import <Nursery/NUTypes.h>
#import <Nursery/NUComparator.h>

@interface NUCRangePair : NSObject
{
    NURegion rangeFrom;
    NURegion rangeTo;
}

+ (instancetype)rangePairWithRangeFrom:(NURegion)aRangeFrom rangeTo:(NURegion)aRangeTo;

- (instancetype)initWithRangeFrom:(NURegion)aRangeFrom rangeTo:(NURegion)aRangeTo;

- (NURegion)rangeFrom;
- (void)setRangeFrom:(NURegion)aRangeFrom;

- (NURegion)rangeTo;
- (void)setRangeTo:(NURegion)aRangeTo;

@end

@interface NUCRangePairFromComparator : NSObject <NUComparator>

+ (instancetype)comparator;

@end

@interface NUCRangePairToComparator : NSObject <NUComparator>

+ (instancetype)comparator;

@end
