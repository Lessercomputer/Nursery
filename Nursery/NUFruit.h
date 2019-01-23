//
//  NUFruit.h
//  Nursery
//
//  Created by Akifumi Takata on 2019/01/16.
//  Copyright © 2019年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@protocol NUFruit <NSObject>

+ (instancetype)fruitWithDescription:(NSString *)aString;
- (instancetype)initWithDescription:(NSString *)aString;

+ (Class)par;
- (instancetype)par;

+ (Class)ser;
- (instancetype)ser;

@end

@interface NUFruit : NSObject <NUFruit>

@end
