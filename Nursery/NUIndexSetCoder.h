//
//  NUIndexSetCoder.h
//  Nursery
//
//  Created by P,T,A on 2013/11/17.
//
//

#import "NUCoder.h"

@interface NUIndexSetCoder : NUCoder

- (void)setIndexesToIndexSet:(NSMutableIndexSet *)anIndexSet withAliaser:(NUAliaser *)anAliaser;

+ (NUUInt64)getRangeCountInIndexSet:(NSIndexSet *)anIndexSet;
+ (void)getRangesInIndexSet:(NSIndexSet *)anIndexSet into:(NUUInt64 *)aRanges;

@end
