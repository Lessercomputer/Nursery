# NUCoder

`+ (id)coder;`  
Returns a new coder.

`- (id)new;`  
When the object to be decoded is mutable, returns a new object to be decoded.

`- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser;`  
Encodes the specified object.

`- (void)encodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser;`  
Encodes the variable length instance variable of the specified object.

`- (void)decode:(id)anObject withAliaser:(NUAliaser *)anAliaser;`  
Decodes the specified object.

`- (void)decodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser;`  
Decodes the variable length instance variable of the specified object.

`- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser;`  
Decodes the object.

`- (BOOL)canMoveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser;`  
Returns whether the specified object can be moved up.

`- (void)moveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser;`  
Reflects the contents of the object in the database to the specified object.