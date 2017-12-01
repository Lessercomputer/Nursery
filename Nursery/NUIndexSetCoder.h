//
//  NUIndexSetCoder.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import "NUCoder.h"
#import "NUTypes.h"

@interface NUIndexSetCoder : NUCoder

- (void)setIndexesToIndexSet:(NSMutableIndexSet *)anIndexSet withAliaser:(NUAliaser *)anAliaser;

+ (NUUInt64)getRangeCountInIndexSet:(NSIndexSet *)anIndexSet;
+ (void)getRangesInIndexSet:(NSIndexSet *)anIndexSet into:(NUUInt64 *)aRanges;

@end
