# NUCharacter Protocol

`+ (BOOL)automaticallyEstablishCharacter;`  
Returns whether or not to automatically call the process to create a character corresponding to the class.

`+ (NUCharacter *)characterOn:(NUGarden *)aGarden;`  
Returns the character corresponding to the class.  
If the corresponding character does not exist, call up the character creation process and return that character.

`+ (NUCharacter *)establishCharacterOn:(NUGarden *)aGarden;`  
Creates a corresponding character or acquires an existing character and returns it.

`+ (NUCharacter *)createCharacterOn:(NUGarden *)aGarden;`  
Creates and returns the corresponding character.

`+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden;`  
Define the object format, instance variables, etc. for the corresponding character.

`+ (NSString *)CharacterNameOn:(NUGarden *)aGarden;`  
Returns the character name.

`- (Class)classForNursery;`  
Returns the class for encoding the instance.