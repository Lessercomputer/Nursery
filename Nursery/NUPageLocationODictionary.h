//
//  NUNodeDictionary.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/03/21.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUU64ODictionary.h"

@class NUPages;

@interface NUPageLocationODictionary : NUU64ODictionary
{
    NUUInt64 pageSize;
}

- (instancetype)initWithPages:(NUPages *)aPages;

@end
