# Nursery  

Nursery is a persistent object framework (object database) for Cocoa.

It is written in Objective-C.  
It is implemented ONLY with the Cocoa Framework.  
It is not ORM.

There is no impedance mismatch.  
Relational database and SQL are not used at all.

Instances of the following classes can be persisted.

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
	A class that implements B+ tree.
* A class that implements the NUCoding protocol.
* A class that implements persistence processing by subclass of NUCoder
		
Objects that can not be traced from the root object of Nursery are automatically released by GC.  
GC can handle circular references correctly. 
GC implements garbage collection with Tri-color marking.  
The released area is compacted.  

Operating environment: OS X version 10.8 or higher
