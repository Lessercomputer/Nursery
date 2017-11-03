//
//  NUNSArray.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/16.
//
//

#import "NUTypes.h"

@interface NSArray (NUCharacter)

- (NUUInt64)indexedIvarsSize;

@end

@interface NUNSArray : NSArray
@end

@interface NUNSMutableArray : NSMutableArray
@end
