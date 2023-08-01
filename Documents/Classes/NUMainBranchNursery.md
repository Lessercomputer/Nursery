# NUMainBranchNursery

`+ (instancetype)nursery;`  
Initializes and returns new nursery.

`+ (id)nurseryWithContentsOfFile:(NSString *)aFilePath;`  
Initializes the nursery with the specified file path and returns it.

`- (id)initWithContentsOfFile:(NSString *)aFilePath;` 
Initializes the nursery with the specified file path and returns it.
 
`- (NSString *)filePath;`  
Returns the file path.

`- (void)setFilePath:(NSString *)aFilePath;`  
Sets the file path.

`- (BOOL)backups;`  
Returns whether or not to back up nursery file.  
Default is NO.

**Note that:**
Simply create a copy of the nursery file before saving. Therefore, it is not recommended that you enable backups except in the early stages of development or when the nursery file is small enough.

`- (void)setBackups:(BOOL)aBackupFlag;`  
Sets whether to perform backup.

`- (BOOL)isOpen;`  
Returns whether it is open or not.