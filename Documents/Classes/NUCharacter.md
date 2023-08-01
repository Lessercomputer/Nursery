# NUCharacter



`- (NUCharacter *)superCharacter;`  
Returns the super character.


`- (NUObjectFormat)format;`  
Returns the format of the object.

`- (void)setFormat:(NUObjectFormat)aFormat;`  
Sets the format of the object.

`- (NUUInt32)version;`  
Returns the version of the character.

`- (void)setVersion:(NUUInt32)aVersion;`  
Sets the version of the character.

`- (NSString *)name;`  
Returns the name of the character.

`- (NSString *)nameWithVersion;`  
Returns the name with version.

`- (NSString *)inheritanceNameWithVersion;`  
Returns the inheritance name with version.

`- (NSArray *)copyIvars;`  
Returns the copy of ivars.

`- (NSArray *)copyAllIvars;`  
Returns the copy of all ivars.

`- (NSArray *)copyAncestors;`  
Returns the copy of Ancestors.

`- (NSSet *)copySubCharacters;`  
Returns the copy of sub characters.
 
`- (void)addOOPIvarWithName:(NSString *)aName;`  
Adds an instance variable of type OOP with the specified name.

`- (void)addInt8IvarWithName:(NSString *)aName;`  
Adds an instance variable of type NUInt8 with the specified name.

`- (void)addInt16IvarName:(NSString *)aName;`  
Adds an instance variable of type NUInt16 with the specified name.

`- (void)addInt32IvarName:(NSString *)aName;`  
Adds an instance variable of type NUInt32 with the specified name.

`- (void)addInt64IvarName:(NSString *)aName;`  
Adds an instance variable of type NUInt64 with the specified name.

`- (void)addUInt8IvarWithName:(NSString *)aName;`  
Adds an instance variable of type NUUInt8 with the specified name.

`- (void)addUInt16IvarName:(NSString *)aName;`  
Adds an instance variable of type NUUInt16 with the specified name.

`- (void)addUInt32IvarName:(NSString *)aName;`  
Adds an instance variable of type NUUInt32 with the specified name.

`- (void)addUInt64IvarWithName:(NSString *)aName;`  
Adds an instance variable of type NUUInt64 with the specified name.

`- (void)addFloatIvarWithName:(NSString *)aName;`  
Adds an instance variable of type NUFloat with the specified name.

`- (void)addDoubleIvarWithName:(NSString *)aName;`  
Adds an instance variable of type NUDouble with the specified name.

`- (void)addBOOLIvarWithName:(NSString *)aName;`  
Adds an instance variable of type BOOL with the specified name.

`- (void)addRangeIvarWithName:(NSString *)aName;`  
Adds an instance variable of type NURange with the specified name.

`- (void)addPointIvarWithName:(NSString *)aName;`  
Adds an instance variable of type NSPoint with the specified name.

`- (void)addSizeIvarWithName:(NSString *)aName;`  
Adds an instance variable of type NSSize with the specified name.

`- (void)addRectIvarWithName:(NSString *)aName;`  
Adds an instance variable of type NSRect with the specified name.

`- (void)addIvarWithName:(NSString *)aName type:(NUIvarType)aType;`  
Adds an instance variable with the specified value.

`- (void)addIvar:(NUIvar *)anIvar;`  
Adds the specified instance variable.

`- (Class)targetClass;`  
Returns the class corresponding to the character.

`- (void)setTargetClass:(Class)aClass;`  
Sets the class corresponding to the character.

`- (Class)coderClass;`  
Returns the coder class that encodes and decodes the instance of the class corresponding to the character.

`- (void)setCoderClass:(Class)aClass;`  
Sets the coder class that encodes and decodes the instance of the class corresponding to the character.

`- (NUCoder *)coder;`  
Returns the instance of the coder.

`- (void)setCoder:(NUCoder *)aCoder;`  
Sets the instance of the coder.

`- (BOOL)isMutable;`  
Returns whether or not the class corresponding to the character is mutable.

`- (void)setIsMutable:(BOOL)aMutableFlag;`  
Sets whether or not the class corresponding to the character is mutable.

`- (BOOL)isEqualToCharacter:(NUCharacter *)aCharacter;`  
Returns whether or not the characters are equal.

`- (BOOL)isRoot;`  
Returns whether or not the character is the root character.

`- (BOOL)formatIsValid;`  
Returns whether the object format is valid.

`- (BOOL)isFixedIvars;`  
Returns whether or not it has fixed-length instance variables.

`- (BOOL)isVariable;`  
Returns whether or not it has variable length instance variables.

`- (BOOL)isIndexedIvars;`  
Returns whether or not it has any variable length instance variables.

`- (BOOL)isFixedAndIndexedIvars;`  
Returns whether it has fixed length and variable length instance variables.

`- (BOOL)isIndexedBytes;`  
Returns whether or not it has variable length bytes.

`- (BOOL)containsIvarWithName:(NSString *)aName;`  
Returns whether or not it contains an instance variable with the specified name.


