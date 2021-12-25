# NUAliaser

`- (BOOL)containsValueForKey:(NSString *)aKey;`  
Returns whether a value for the specified key exists.

`- (void)encodeObject:(id)anObject;`  
Encodes the specified object.

`- (void)encodeBOOL:(BOOL)aValue;`  
Encodes the specified value.

`- (void)encodeInt8:(NUInt8)aValue;`  
Encodes the specified value.

`- (void)encodeInt16:(NUInt16)aValue;`  
Encodes the specified value.

`- (void)encodeInt32:(NUInt32)aValue;`  
Encodes the specified value.

`- (void)encodeInt64:(NUInt64)aValue;`  
Encodes the specified value.

`- (void)encodeUInt8:(NUUInt8)aValue;`  
Encodes the specified value.

`- (void)encodeUInt16:(NUUInt16)aValue;`  
Encodes the specified value.

`- (void)encodeUInt32:(NUUInt32)aValue;`  
Encodes the specified value.

`- (void)encodeUInt64:(NUUInt64)aValue;`  
Encodes the specified value.

`- (void)encodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount;`  
Encodes the specified values.

`- (void)encodeFloat:(NUFloat)aValue;`  
Encodes the specified value.

`- (void)encodeDouble:(NUDouble)aValue;`  
Encodes the specified value.

`- (void)encodeRegion:(NURegion)aValue;`  
Encodes the specified value.

`- (void)encodeRange:(NSRange)aValue;`  
Encodes the specified value.

`- (void)encodePoint:(NUPoint)aValue;`  
Encodes the specified value.

`- (void)encodeSize:(NUSize)aValue;`  
Encodes the specified value.

`- (void)encodeRect:(NURect)aValue;`  
Encodes the specified value.

`- (void)encodeObject:(id)anObject forKey:(NSString *)aKey;`  
Encodes the specified object with the specified key.

`- (void)encodeInt8:(NUInt8)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeInt16:(NUInt16)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeInt32:(NUInt32)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeInt64:(NUInt64)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeUInt8:(NUUInt8)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeUInt16:(NUUInt16)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeUInt32:(NUUInt32)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeUInt64:(NUUInt64)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeFloat:(NUFloat)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeDouble:(NUDouble)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeBOOL:(BOOL)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeRegion:(NURegion)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeRange:(NSRange)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodePoint:(NUPoint)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeSize:(NUSize)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeRect:(NURect)aValue forKey:(NSString *)aKey;`  
Encodes the specified value with the specified key.

`- (void)encodeIndexedIvars:(id *)anIndexedIvars count:(NUUInt64)aCount;`  
Encodes a variable length instance variable of an object whose object format is NUIndexedIvars or NUFixedAndIndexedIvars.

`- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount;`  
Encodes a variable length instance variable of an object whose object format is NUIndexedBytes.

`- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)anOffset;`  
Encodes a variable length instance variable of an object whose object format is NUIndexedBytes.

`- (id)decodeObject;`  
Decodes the object.

`- (id)decodeObjectReally;`  
Really decodes the object.

`- (BOOL)decodeBOOL;`  
Decodes the BOOL value.

`- (NUInt8)decodeInt8;`  
Decodes the NUInt8 value.

`- (NUInt16)decodeInt16;`  
Decodes the NUInt16 value.

`- (NUInt16)decodeInt32;`  
Decodes the NUInt32 value.

`- (NUInt64)decodeInt64;`  
Decodes the NUInt64 value.

`- (NUUInt8)decodeUInt8;`  
Decodes the NUUInt8 value.

`- (NUUInt16)decodeUInt16;`  
Decodes the NUUInt16 value.

`- (NUUInt32)decodeUInt32;`  
Decodes the NUUInt32 value.

`- (NUUInt64)decodeUInt64;`  
Decodes the NUUInt64 value.

`- (void)decodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount;`  
Decodes the array of NUUInt64.

`- (NUFloat)decodeFloat;`  
Decodes the float value.

`- (NUDouble)decodeDouble;`  
Decodes the double value.

`- (NURegion)decodeRegion;`  
Decodes the NURegion value.

`- (NSRange)decodeRange;`  
Decodes the NSRange value.

`- (NSPoint)decodePoint;`  
Decodes the NSPoint value.

`- (NSSize)decodeSize;`  
Decodes the NSSize value.

`- (NSRect)decodeRect;`  
Decodes the NSRect value.

`- (id)decodeObjectForKey:(NSString *)aKey;`  
Decodes the object corresponding to the specified key.

`- (id)decodeObjectReallyForKey:(NSString *)aKey;`  
Really decodes the object corrensponding to the specified key.

`- (NUInt8)decodeInt8ForKey:(NSString *)aKey;`  
Decodes the NUInt8 value corresponding to the specified key.

`- (NUInt16)decodeInt16ForKey:(NSString *)aKey;`  
Decodes the NUInt16 value corresponding to the specified key.

`- (NUInt32)decodeInt32ForKey:(NSString *)aKey;`  
Decodes the NUInt32 value corresponding to the specified key.

`- (NUInt64)decodeInt64ForKey:(NSString *)aKey;`  
Decodes the NUInt64 value corresponding to the specified key.

`- (NUUInt8)decodeUInt8ForKey:(NSString *)aKey;`  
Decodes the NUUInt8 value corresponding to the specified key.

`- (NUUInt16)decodeUInt16ForKey:(NSString *)aKey;`  
Decodes the NUUInt16 value corresponding to the specified key.

`- (NUUInt32)decodeUInt32ForKey:(NSString *)aKey;`  
Decodes the NUUInt32 value corresponding to the specified key.

`- (NUUInt64)decodeUInt64ForKey:(NSString *)aKey;`  
Decodes the NUUInt64 value corresponding to the specified key.

`- (NUFloat)decodeFloatForKey:(NSString *)aKey;`  
Decodes the float value corresponding to the specified key.

`- (NUDouble)decodeDoubleForKey:(NSString *)aKey;`  
Decodes the double value corresponding to the specified key.

`- (BOOL)decodeBOOLForKey:(NSString *)aKey;`  
Decodes the BOOL value corresponding to the specified key.

`- (NURegion)decodeRegionForKey:(NSString *)aKey;`  
Decodes the NURegion value corresponding to the specified key.

`- (NSRange)decodeRangeForKey:(NSString *)aKey;`  
Decodes the NSRange value corresponding to the specified key.

`- (NUPoint)decodePointForKey:(NSString *)aKey;`  
Decodes the NSPoint value corresponding to the specified key.

`- (NUSize)decodeSizeForKey:(NSString *)aKey;`  
Decodes the NSSize value corresponding to the specified key.

`- (NURect)decodeRectForKey:(NSString *)aKey;`  
Decodes the NSRect value corresponding to the specified key.

`- (void)decodeIndexedIvar:(id *)anIndexedIvars count:(NUUInt64)aCount really:(BOOL)aReallyDecode;`  
Decodes a variable length instance variable of an object whose object format is NUIndexedIvars or NUFixedAndIndexedIvars.

`- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount;`  
Decodes a variable length instance variable of an object whose object format is NUIndexedBytes.

`- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)aLocation;`  
Decodes a variable length instance variable of an object whose object format is NUIndexedBytes.

`- (void)moveUp:(id)anObject;`  
Reflects the contents of the latest object in the database to the specified object.

`- (void)moveUp:(id)anObject ignoreGradeAtCallFor:(BOOL)anIgnoreFlag;`  
Reflects the contents of the latest object in the database to the specified object.  
If anIgnoreFlag is YES, reflection processing is performed even when the grade at the time of reading the contents of the object matches the grade of the object on the database.
