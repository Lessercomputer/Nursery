# Nursery  
**Nursery** is an embeddable object-oriented database (OODB) framework for Cocoa

## Licence
**Nursery** is published under the zlib license

## Donation
[Donate with PayPal (paypal.me/AkifumiTakata)](https://paypal.me/AkifumiTakata)

## Overview
* Simple & Powerful
* Written in Objective-C
* Implemented ONLY with the Foundation framework of Cocoa and Core Foundation Framework (for creating sockets)
* ACID-compliant
* Lazy Loading
* Garbage Collection and Compaction in Database File
* Simultaneous Use from Multiple Processes
* Not ORM(Object-relational mapping)


### List of Persistable Objects
* NULibrary  
	A collection class that implements **B+ tree**.
* A class that implements the **NUCoding** protocol.
* A class that implements persistence processing by subclass of **NUCoder**
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

### Very Simple Example 
```objc
#import <Nursery/Nursery.h>

NUMainBranchNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:@"path/to/file"];
NUGarden *aGarden = [aNursery makeGarden];

[aGarden setRoot:@"Hi, I'm Nursery"];
    
[aGarden farmOut];
```

### Example Using NUCoding Protocol
```objc
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
macOS (10.8 or higher)

## How to buld
1. Click "Open in Xcode" on project page and clone to (For Example) your Desktop 
2. Select "Edit Scheme..." < "Scheme" < "Product" in menubar
3. Select "Run" in left pane and change "Build Configuration" to "Release" then click "Close" button
4. Select "Build" < "Product" in menubar

## A bit more detailed information
### Endian Independent
Instance variables are converted to big endian at the time of encoding and converted to host endian at the time of decoding

### Thread Safety
Loading and saving objects is thread-safe.  
However, there is no guarantee that other processing is thread-safe

### Simultaneous Use from Multiple Processes
**Nursery** supports simultaneous use with multiple processes

### Durability
**Nursery** implements write-ahead logging (WAL)

### Garbage Collection in Database File
Objects that can not be traced from the root object of **Nursery** are automatically released by GC.  
GC can handle circular references correctly.  
GC implements garbage collection with Tri-color marking.  
The released area is compacted 

## See also
* [API Documentation](https://gitlab.com/AkifumiTakata/documentation-for-nursery)  
* [Examples](https://gitlab.com/AkifumiTakata/examples-of-nursery)  
* [Nursery Net Service App for macOS](https://gitlab.com/AkifumiTakata/nursery-net-service-app)
* [Bookmarks App for macOS](https://gitlab.com/AkifumiTakata/bookmarks)

## Contribution
Bug fixes are welcome
