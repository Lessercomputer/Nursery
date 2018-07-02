# Nursery  
**Nursery** is a persistent object framework (object-oriented database) for Cocoa.

## Overview
* Written in Objective-C.  
* Implemented ONLY with the Foundation framework of Cocoa and Core Foundation framework(for creating sockets). 
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

## macOS support
macOS(10.8 or higher)

## Licence
**Nursery** is published under the zlib license.

