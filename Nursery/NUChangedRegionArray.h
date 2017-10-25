//
//  NUChangedRegionArray.h
//  Nursery
//
//  Created by P,T,A on 11/01/22.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NURegionArray.h"


@interface NUChangedRegionArray : NURegionArray
{
}
@end

@interface NUChangedRegionArray (InitializingAndRelease)

- (id)initWithCapacity:(NUUInt32)aCapacity;

@end

@interface NUChangedRegionArray (Modifying)

- (void)addRegion:(NURegion)aRegion;
- (void)replaceRegionRange:(NURegion)aReplaceRange with:(NURegion)aRegion;

@end

@interface NUChangedRegionArray (Querying)

- (NUUInt32)firstIntersectingRegionIndexWith:(NURegion)aRegion;
- (NURegion)intersectingRegionRangeWith:(NURegion)aRegion;

@end
