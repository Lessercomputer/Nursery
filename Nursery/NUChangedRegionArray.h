//
//  NUChangedRegionArray.h
//  Nursery
//
//  Created by Akifumi Takata on 11/01/22.
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
