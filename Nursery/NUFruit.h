//
//  NUFruit.h
//  Nursery
//
//  Created by Akifumi Takata on 2019/01/16.
//  Copyright © 2019年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@interface NUFruit : NSObject

+ (id)Fruit;
+ (id)fruit;
- (id)Fruit;
- (id)fruit;

@end

@interface NUA : NUFruit

+ (id)A;
+ (id)a;
- (id)A;
- (id)a;

@end

@interface NUIs : NUFruit

+ (id)Is;
+ (id)is;
- (id)Is;
- (id)is;

@end

@interface NUDo : NUFruit

+ (id)Do;
+ (id)do;
- (id)Do;
- (id)do;

@end

@interface NUSerially : NUFruit

+ (id)serially;
- (id)Serially;
- (id)serially;

@end

@interface NUParalelly : NUFruit

@end

@interface NUThen : NUFruit

+ (id)Then;
+ (id)then;
- (id)Then;
- (id)then;

@end

@interface NUNo : NUFruit

+ (id)No;
+ (id)no;
- (id)No;
- (id)no;

@end

@interface NUDescription : NUFruit

+ (id)Description:(NSString *)aString;

//+ (id)fruitWithString:(NSString *)aString;

- (id)init:(NSString *)aString;

//- (id)description;
//+ (NSString *)description;
//- (NSString *)Description;
+ (NSString *)Description;
- (NSString *)description;

@end
