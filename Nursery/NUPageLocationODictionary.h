//
//  NUNodeDictionary.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/03/21.
//

#import "NUU64ODictionary.h"

@class NUPages;

@interface NUPageLocationODictionary : NUU64ODictionary
{
    NUUInt64 pageSize;
}

- (instancetype)initWithPages:(NUPages *)aPages;

@end
