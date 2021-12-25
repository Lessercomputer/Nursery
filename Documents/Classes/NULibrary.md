# NULibrary

`+ (id)library;`  
Returns a new library.

`+ (id)libraryWithComparator:(id <NUComparator>)aComparator;`  
Creates and returns a new library with the specified comparator.

`- (id)init;`  
Initializes the library.

`- (id)initWithComparator:(id <NUComparator>)aComparator;`  
Initialize the library with the specified comparator.

`- (id)objectForKey:(id)aKey;`  
Returns the object corresponding to the specified key.

`- (void)setObject:(id)anObject forKey:(id)aKey;`  
Sets the specified key and object.

`- (void)removeObjectForKey:(id)aKey;`  
Removes the specified key and the corresponding object.

`- (id)firstKey;`  
Returns the first (minimum) key.  
If it does not exist, nil is returned.

`- (id)lastKey;`  
Returns the last (maximum) key.  
If it does not exist, nil is returned.

`- (id)keyGreaterThanOrEqualTo:(id)aKey;`  
Returns the key that is greater than or equal to the specified key.  
If it does not exist, nil is returned.

`- (id)keyGreaterThan:(id)aKey;`  
Returns a key greater than the specified key.  
If it does not exist, nil is returned.

`- (id)keyLessThanOrEqualTo:(id)aKey;`  
Returns the key that is less than or equal to the specified key.  
If it does not exist, nil is returned.

`- (id)keyLessThan:(id)aKey;`  
Returns the key that is less than the specified key.  
If it does not exist, nil is returned.
 
`- (NUUInt64)count;`  
Returns the number of pairs of keys and objects.

`- (id <NUComparator>)comparator;`  
Returns a comparator.

`- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;`  
Enumerate keys and objects using a block.

`- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;`

`- (void)enumerateKeysAndObjectsWithKeyGreaterThan:(id)aKey orEqual:(BOOL)anOrEqualFlag options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;`  
Enumerate keys and objects using a block.

`- (void)enumerateKeysAndObjectsWithKeyLessThan:(id)aKey orEqual:(BOOL)anOrEqualFlag options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;`  
Enumerate keys and objects using a block.

`- (void)enumerateKeysAndObjectsWithKeyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 andKeyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;`  
Enumerate keys and objects using a block.

`- (BOOL)isEqualToLibrary:(NULibrary *)aLibrary;`  
Returns whether or not it is equal to the specified library.

`- (void)moveUp;`  
Dscards unsaved changes and reflect latest state of object in database to the object.