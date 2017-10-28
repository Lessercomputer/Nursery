# Nursery
Nursery is a persistent object framework (object database) for Cocoa.

It is written in Objective-C.
It is implemented ONLY with the Cocoa Framework.

Instances of the following classes can be persisted.

	• NSObject
	• NSString
	• NSMutableString
	• NSArray
	• NSMutableArray
	• NSDictionary
	• NSMutableDictionary
	• NSSet
	• NSMutableSet
	• NSNumber
	• NSDate
	• NSURL
	• NSData
	• NSMutableData
	• NSIndexSet
	• NSMutableIndexSet
	• NULibrary
		A class that implements B+ tree.
	• A class that implements the NUCoding protocol.
	• A class that implements persistence processing by subclass of NUCoder
		
Objects no longer referenced by Nursery's root object are automatically released by the GC.
The released area is compacted.

Operating environment: OS X version 10.8 or higher
