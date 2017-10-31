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

# The following is a quote from the Cocoa-dev mailing list.
Regarding the durability, I am carrying out write ahead logging (WAL) In order to avoid corruption of data already recorded on the database. At least existing data will not be lost if power is lost or crashed while writing.

Loading the object into memory, the root object is first loaded when the root method of the instance of NUSandbox's subclass is called.

The timing at which each object loads its instance variables depends on how you implemented the NUCoding protocol.
Initializer of NUCoding protocol By implementing to load instance variable inside initWithAliaser: method, instance variable is load at object initialization.
If you use the NUGetIver() function to load an instance variable in the accessor method of the object implementing the NUCoding protocol, it will be read when the accessor method is first called.

Supplementally, the subclass of NUCoder is a class for persisting instances of classes that do not implement the NUCoding protocol such as existing NSString and NSArray.
An instance of a class persisted in an instance of a subclass of NUCoder normally loads its instance variables all at once when initializing the object.

But even then, the instance variable of the object stored in the instance of NSArray will be loaded, depending on how the object implemented persistence.

The timing when the loaded object is freed from memory is when the object can not be traced from the root object of the instance of the subclass of NUSandbox and the reference count reaches zero.

In order to persist the loaded object again, you need to call that object changed as an argument to the instance of NUSandbox's subclass with the object changed to the markChangedObject: method.
Also, since the object implementing the NUCoding protocol refers to an instance of NUBell, you can use a convenience method like [[self bell] markChanged] inside its accessor method etc.

Multiple processes can simultaneously use instances of the same NUNursery subclass.
Within the framework distributed objects are used for communication between processes.
