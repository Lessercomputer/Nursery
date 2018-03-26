//
//  SelfReferencedObject.h
//  NurseryTests
//
//  Created by Akifumi Takata on 2018/03/26.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@interface SelfReferenceObject : NSObject <NUCoding>
{
    SelfReferenceObject *myself;
}

@property (nonatomic, assign) NUBell *bell;

- (SelfReferenceObject *)myself;
- (void)setMyself:(SelfReferenceObject *)aMyself;

@end
