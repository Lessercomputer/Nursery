# NUBell

`+ (id)bellWithBall:(NUBellBall)aBall;`  
Initializes with the specified value and returns it.

`+ (id)bellWithBall:(NUBellBall)aBall garden:(NUGarden *)aGarden;`  
Initializes with the specified value and returns it.

`+ (id)bellWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded garden:(NUGarden *)aGarden;`  
Initializes with the specified value and returns it.

`- (id)initWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded garden:(NUGarden *)aGarden;`  
Initializes with the specified value and returns it.

`- (NUBellBall)ball;`  
Returns the bellball.

`- (NUUInt64)OOP;`  
Returns the OOP.

`- (NUUInt64)grade;`  
Returns the grade.

`- (NUUInt64)gradeAtCallFor;`  
Returns the grade at call for.

`- (NUGarden *)garden;`  
Returns the garden.

`- (id)object;`  
Returns the object represented by the bell.

`- (BOOL)isLoaded;`  
Returns whether the object represented by the bell has been loaded.

`- (BOOL)hasObject;`  
Returns whether there is an object.

`- (BOOL)isEqualToBell:(NUBell *)anOOP;`  
Returns whether or not it is the same as the specified bell.

`- (void)markChanged;`  
Marks the object represented by the bell as changed.

`- (void)unmarkChanged;`  
Unmarks the object represented by the bell as changed.

`- (BOOL)gradeIsUnmatched;`  
Returns whether or not grade is unmatched.

`- (BOOL)isBell`  
Returns YES.
