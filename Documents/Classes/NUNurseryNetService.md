# NUNurseryNetService

`+ (instancetype)netServiceWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;`
Initializes and returns a net service with the specified value.

`- (instancetype)initWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;`
Initializes and returns a net service with the specified value.

`- (void)start;`  
Starts the net service.  
This method is thread-safe.

`- (void)stop;`  
Stops the net service.  
This method is thread-safe.

`- (BOOL)isRunning;`  
Returns whether or not is running.