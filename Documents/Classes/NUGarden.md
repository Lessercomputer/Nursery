# NUGarden

`+ (id)gardenWithNursery:(NUNursery *)aNursery;`  
Initializes and returns a garden with the specified value.

`+ (id)gardenWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker;`  
Initializes and returns a garden with the specified value.

`+ (id)gardenWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker;	`  
Initializes and returns a garden with the specified value.

`+ (id)gardenWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag;`
Initializes and returns a garden with the specified value.

`+ (id)gardenWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag;`  
Initializes and returns a garden with the specified value.

`- (id)initWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag;`  
Initializes and returns a garden with the specified value.

`- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag;`
Initializes and returns a garden with the specified value.

`- (NUNursery *)nursery;`  
Returns the nursery referenced by the garden.

`- (NUUInt64)grade;`  
Returns the grade of the garden.

`- (id)root;`  
Returns the root of the garden.

`- (void)setRoot:(id)aRoot;`  
Sets the root of the garden.

`- (void)addCharacterTargetClassResolver:(id <NUCharacterTargetClassResolving>)aTargetClassResolver;` 
Adds the specified CharacterTargetClassResolver.

`- (void)removeCharacterTargetClassResolver:(id <NUCharacterTargetClassResolving>)aTargetClassResolver;`  
Removes the specified CharacterTargetClassResolver.

`- (void)moveUp;`  
Reads the system objects in the garden from the database and updates them to the latest state.
It does not update user objects such as root.

`- (void)moveUpWithPreventingReleaseOfCurrentGrade;`  
It is the same as the moveUp method except that the current grade is not subject to GC.

`- (void)moveUpTo:(NUUInt64)aGrade;`  
Loads system objects in the garden from the database and updates them to the state of the specified grade.  
It does not update user objects such as root.

`- (void)moveUpTo:(NUUInt64)aGrade preventReleaseOfCurrentGrade:(BOOL)aPreventFlag;`  
Loads system objects in the garden from the database and updates them to the state of the specified grade.  
It does not update user objects such as root.
If aPreventFlag is YES, the current grade will not be subject to GC. 

`- (void)moveUpObject:(id)anObject;`  
Calls the moveUpWithAliaser: method on the specified object.

`- (NUFarmOutStatus)farmOut;`  
Saves the changed objects in the garden to the database.

`- (BOOL)objectIsChanged:(id)anObject;`  
Returns wheter or not the specified object is changed.

`- (void)markChangedObject:(id)anObject;`  
Marks the specified object as a changed object.

`- (void)unmarkChangedObject:(id)anObject;`  
Unmarks the specified object as a changed object.

