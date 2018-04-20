//
//  Person.m
//  Nursery
//
//  Created by Akifumi Takata on 2012/09/29.
//
//

#import "Person.h"

static NUUInt32 characterVersion = 0;

@implementation Person

+ (NUUInt32)characterVersion
{
    return characterVersion;
}

+ (void)setCharacterVersion:(NUUInt32)aVersion
{
    characterVersion = aVersion;
}

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter setVersion:[self characterVersion]];
 
    [aCharacter addOOPIvarWithName:@"firstName"];
    if ([self characterVersion] >= 1)
        [aCharacter addOOPIvarWithName:@"middleName"];
    [aCharacter addOOPIvarWithName:@"lastName"];
    if ([self characterVersion] == 2)
        [aCharacter addUInt64IvarWithName:@"age"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    [anAliaser encodeObject:firstName];
    if ([[anAliaser character] version] >= 1)
        [anAliaser encodeObject:middleName];
    [anAliaser encodeObject:lastName];
    if ([[anAliaser character] version] == 2)
        [anAliaser encodeUInt64:age];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    [super init];
    
    age = 0;
    
    firstName = [[anAliaser decodeObject] retain];
    if ([[anAliaser character] version]  >= 1)
        middleName = [[anAliaser decodeObject] retain];
    lastName = [[anAliaser decodeObject] retain];
    if ([[anAliaser character] version] == 2)
        age = [anAliaser decodeUInt64];
    
    return self;
}

- (NUBell *)bell
{
    return bell;
}

- (void)setBell:(NUBell *)aBell
{
    bell = aBell;
}

- (id)initWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName
{
    [super init];
    
    firstName = [aFirstName retain];
    lastName = [aLastName retain];
    age = 0;
    
    return self;
}

- (void)dealloc
{
    [firstName release];
    [middleName release];
    [lastName release];
    
    [super dealloc];
}

- (NSString *)firstName
{
    return NUGetIvar(&firstName);
}

- (void)setFirstName:(NSString *)aString
{    
    NUSetIvar(&firstName, aString);
}

- (NSString *)middleName
{
    return NUGetIvar(&middleName);
}

- (void)setMiddleName:(NSString *)aString
{
    NUSetIvar(&middleName, aString);
}

- (NSString *)lastName
{
    return NUGetIvar(&lastName);
}

- (void)setLastName:(NSString *)aString
{
    NUSetIvar(&lastName, aString);
}

- (NUUInt64)age
{
    return age;
}

- (void)setAge:(NUUInt64)anAge
{
    age = anAge;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) return YES;
    
    if (![[self firstName] isEqual:[object firstName]])
        return NO;
    
    if ([[self class] characterVersion] >= 1 && ![[self middleName] isEqual:[object middleName]])
        return NO;
        
    if (![[self lastName] isEqual:[object lastName]])
        return NO;
    
    if ([[self class] characterVersion] == 2 && age != [object age])
        return NO;
    
    return YES;
}

- (id)retain
{
    return [super retain];
}

- (oneway void)release
{
    [super release];
}

- (id)autorelease
{
    return [super autorelease];
}

@end
