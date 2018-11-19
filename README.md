# Nursery  
**Nursery** is an embeddable object-oriented database framework for Cocoa.

## Overview
* Written in Objective-C.  
* Implemented ONLY with the Foundation framework of Cocoa and Core Foundation framework (for creating sockets). 
* ACID characteristics.  
* Lazy loading.
* Garbage Collection and Compaction.
* Simultaneous use from multiple processes.
* Not ORM(Object-relational mapping).  


### List of persistable objects
* NSObject
* NSString
* NSMutableString
* NSArray
* NSMutableArray
* NSDictionary
* NSMutableDictionary
* NSSet
* NSMutableSet
* NSNumber
* NSDate
* NSURL
* NSData
* NSMutableData
* NSIndexSet
* NSMutableIndexSet
* NULibrary  
	A collection class that implements **B+ tree**.
* A class that implements the **NUCoding** protocol.
* A class that implements persistence processing by subclass of **NUCoder**
		
### Endian independent
Instance variables are converted to big endian at the time of encoding and converted to host endian at the time of decoding.

### Thread safety
Loading and saving objects is thread-safe.  
However, there is no guarantee that other processing is thread-safe.

### Simultaneous use from multiple processes
**Nursery** supports simultaneous use with multiple processes.

### Durability
**Nursery** implements write-ahead logging (WAL).

### Garbage collection
Objects that can not be traced from the root object of **Nursery** are automatically released by GC.  
GC can handle circular references correctly.  
GC implements garbage collection with Tri-color marking.  
The released area is compacted.  

### Example
```
#import <Nursery/Nursery.h>

NUMainBranchNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:@"path/to/file"];
NUGarden *aGarden = [aNursery makeGarden];
    
Person *aPerson = [Person new];

[aPerson setFirstName:@"Akifumi"];
[aPerson setLastName:@"Takata"];

[aGarden setRoot:aPerson];
    
[aGarden farmOut];

// Person Class
@interface Person : NSObject <NUCoding>
{
    NSString *firstName;
    NSString *lastName;
}

@property (weak) NUBell *bell;

- (NSString *)firstName;
- (void)setFirstName:(NSString *)aFirstName;

- (NSString *)lastName;
- (void)setLastName:(NSString *)aLastName;

@end

@implementation Person

+ (BOOL)automaticallyEstablishCharacter
{
    return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter addOOPIvarWithName:@"firstName"];
    [aCharacter addOOPIvarWithName:@"lastName"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    [anAliaser encodeObject:firstName forKey:@"firstName"];
    [anAliaser encodeObject:lastName forKey:@"lastName"];
}

- (instancetype)initWithAliaser:(NUAliaser *)anAliaser
{
    self = [super init];
    if (self)
    {
        firstName = [anAliaser decodeObjectForKey:@"firstName"];
        lastName = [anAliaser decodeObjectForKey:@"lastName"];
    }
    return self;
}

- (NSString *)firstName
{
    return NUGetIvar(&firstName);
}

- (void)setFirstName:(NSString *)aFirstName
{
    NUSetIvar(&firstName, aFirstName);
    [[self bell] markChanged];
}

- (NSString *)lastName
{
    return NUGetIvar(&lastName);
}

- (void)setLastName:(NSString *)aLastName
{
    NUSetIvar(&lastName, aLastName);
    [[self bell] markChanged];
}

@end
```

## macOS support
macOS(10.8 or higher)

## Licence
**Nursery** is published under the zlib license.

## Donation
[Donate with PayPal (paypal.me/AkifumiTakata)](https://paypal.me/AkifumiTakata)