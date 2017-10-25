//
//  NUNSDictionary.h
//  Nursery
//
//  Created by P,T,A on 2013/11/16.
//
//

#import <Nursery/NUTypes.h>

@interface NSDictionary (NUCharacter)

- (NUUInt64)indexedIvarsSize;

@end

@interface NUNSDictionary : NSDictionary
@end

@interface NUNSMutableDictionary : NSMutableDictionary
@end