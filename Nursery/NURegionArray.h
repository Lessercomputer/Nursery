//
//  NURegionArray.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/19.
//

#import "NUOpaqueArray.h"


@interface NURegionArray : NUOpaqueArray
{

}

- (id)initWithCapacity:(NUUInt32)aCapacity comparator:(NUInt (*)(NUUInt8 *, NUUInt8 *))aComparator;

- (void)insertRegion:(NURegion)aRegion to:(NUUInt32)anIndex;
- (NURegion)regionAt:(NUUInt32)anIndex;
- (void)replaceRegionAt:(NUUInt32)anIndex with:(NURegion)aRegion;

@end
