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

@interface NUThen : NUFruit

+ (id)Then;
+ (id)then;
- (id)Then;
- (id)then;

@end

@interface NUFruit (No)

+ (id)No;
+ (id)no;
- (id)No;
- (id)no;

@end

@interface NUFruit (Do)

- (id)do;

@end

@interface NUFruit (Serially)

- (id)serially;

@end

@interface NUFruit (DoInSerial)

//+ (id)DoInSerial;
- (id)doInSerial;

@end

@interface NUFruit (DoInParallel)

- (id)doInParallel;

@end

@interface NUFruit (Foundation_init)

+ (id)FruitWithDescription:(NSString *)aString;

//+ (id)fruitWithString:(NSString *)aString;

- (id)initWithDescription:(NSString *)aString;

//- (id)description;

@end

@interface NUFruit (Foundation_description)

//+ (NSString *)description;
//- (NSString *)Description;
+ (NSString *)Description;
- (NSString *)description;

@end
