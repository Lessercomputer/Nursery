# Nursery  
**Nursery** is a persistent object framework (object database) for Cocoa.

## Overview
It is written in Objective-C.  
It is implemented ONLY with the Foundation framework of Cocoa.  
It is **not** ORM(Object-relational mapping).

There is no impedance mismatch.  
Relational database and SQL are not used at all.



## List of persistable objects

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
	A collection class that implements B+ tree.
* A class that implements the **NUCoding** protocol.
* A class that implements persistence processing by subclass of **NUCoder**
		
## Thread safety
Loading and saving objects is thread-safe.  
However, there is no guarantee that other processing is thread-safe.

## Durability
**Nursery** implements write-ahead logging (WAL).

## Garbage collection
Objects that can not be traced from the root object of **Nursery** are automatically released by GC.  
GC can handle circular references correctly.  
GC implements garbage collection with Tri-color marking.  
The released area is compacted.  

## macOS support
macOS(10.8 or higher)

## Licence
**Nursery** is published under the zlib license.

