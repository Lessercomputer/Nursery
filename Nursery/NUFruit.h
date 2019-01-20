//
//  NUFruit.h
//  Nursery
//
//  Created by Akifumi Takata on 2019/01/16.
//  Copyright © 2019年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@protocol NUFruit <NSObject>

+ (instancetype)fruit;
+ (instancetype)fruitWithDescription:(NSString *)aString;

- (instancetype)initWithDescription:(NSString *)aString;

- (instancetype)do;
- (instancetype)parallelly;
- (instancetype)serially;

@end

@interface NUFruit : NSObject <NUFruit>

@end

