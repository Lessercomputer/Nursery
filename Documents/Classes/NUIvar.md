# NUIvar

`+ (id)ivarWithName:(NSString *)aName type:(NUIvarType)aType;`  
Initializes and returns the instance variable definition with the specified value.

`+ (id)ivarWithName:(NSString *)aName type:(NUIvarType)aType size:(NUUInt64)aSize;`  
Initializes and returns the instance variable definition with the specified value.

`- (id)initWithName:(NSString *)aName type:(NUIvarType)aType;`  
Initialize the instance variable definition with the specified value.

`- (id)initWithName:(NSString *)aName type:(NUIvarType)aType size:(NUUInt64)aSize;`  
Initialize the instance variable definition with the specified value.

`- (NSString *)name;`  
Returns the name of the instance variable.

`- (void)setName:(NSString *)aName;`  
Sets the name of the instance variable.

`- (NUIvarType)type;`  
Returns the type of the instance variable.

`- (void)setType:(NUIvarType)aType;`  
Sets the type of the instance variable.

`- (NUUInt64)size;`  
Returns the size (count) of the instance variable.

`- (void)setSize:(NUUInt64)aSize;`  
Sets the size (count) of the instance variable.

`- (NUUInt64)sizeInBytes;`  
Returns the number of bytes in the instance variable.

`- (NUUInt64)offset;`  
Returns the offset of the instance variables within the object.

`- (BOOL)isEqualToIvar:(NUIvar *)anIvar;`  
Returns whether the two instance variable definitions are equal or not.