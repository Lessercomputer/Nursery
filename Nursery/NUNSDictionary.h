//
//  NUNSDictionary.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/16.
//
//

#import <Foundation/NSDictionary.h>

#import "NUTypes.h"

@interface NSDictionary (NUCharacter)

- (NUUInt64)indexedIvarsSize;

@end

@interface NUNSDictionary : NSDictionary
@end

@interface NUNSMutableDictionary : NSMutableDictionary
@end
