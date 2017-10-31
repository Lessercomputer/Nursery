//
//  Person.h
//  Nursery
//
//  Created by Akifumi Takata on 2012/09/29.
//
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@interface Person : NSObject <NUCoding>
{
    NSString *firstName;
    NSString *middleName;
    NSString *lastName;
    NUUInt64 age;
    NUBell *bell;
}

+ (NUUInt32)characterVersion;
+ (void)setCharacterVersion:(NUUInt32)aVersion;

- (id)initWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName;

- (NSString *)firstName;
- (void)setFirstName:(NSString *)aString;

- (NSString *)middleName;
- (void)setMiddleName:(NSString *)aString;

- (NSString *)lastName;
- (void)setLastName:(NSString *)aString;

- (NUUInt64)age;
- (void)setAge:(NUUInt64)anAge;

@end
