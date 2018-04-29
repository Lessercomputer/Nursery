//
//  NUNurseryNetService+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/29.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUNurseryNetService.h"

@class NUNurseryNetResponder;


@interface NUNurseryNetService (Private)

- (NUMainBranchNursery *)nursery;

- (void)netResponderDidStop:(NUNurseryNetResponder *)sender;

@end
