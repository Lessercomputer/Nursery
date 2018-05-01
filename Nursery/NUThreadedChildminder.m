//
//  NUThreadedChildminder.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/03/16.
//
//

#import <Foundation/NSLock.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSString.h>

#import "NUThreadedChildminder.h"
#import "NUMainBranchNursery.h"

const int NUThreadedChildminderActiveCondition      = 0;
const int NUThreadedChildminderDeactiveCondition    = 1;
const int NUThreadedChildminderTerminateCondition   = 2;

@implementation NUThreadedChildminder

+ (id)threadedChildminderWithGarden:(NUGarden *)aGarden
{
	return [[[self alloc] initWithGarden:aGarden] autorelease];
}

- (id)initWithGarden:(NUGarden *)aGarden
{
	if (self = [super init])
    {
        garden = aGarden;
        shouldTerminate = NO;
        shouldStop = NO;
        conditionLock = [[NSConditionLock alloc] initWithCondition:NUThreadedChildminderDeactiveCondition];
    }
    
	return self;
}

- (void)dealloc
{
    [self setGarden:nil];

	[conditionLock release];
	
	[super dealloc];
}

- (NUGarden *)garden
{
    return garden;
}

- (void)setGarden:(NUGarden *)aGarden
{
    garden = aGarden;
}

- (NSString *)threadName
{
    return [NSString stringWithFormat:@"org.nursery-framework.%@", self];
}

- (void)prepare
{
    NSThread *aThread = [[[NSThread alloc] initWithTarget:self selector:@selector(startThread:) object:nil] autorelease];
    [aThread setName:[self threadName]];
    [aThread start];
}

- (void)start
{
	shouldStop = NO;
	[conditionLock lockWhenCondition:NUThreadedChildminderDeactiveCondition];
	[conditionLock unlockWithCondition:NUThreadedChildminderActiveCondition];
}

- (void)startWithoutWait
{
    shouldStop = NO;
}

- (void)stop
{
	shouldStop = YES;
	[conditionLock lockWhenCondition:NUThreadedChildminderDeactiveCondition];
	[conditionLock unlockWithCondition:NUThreadedChildminderDeactiveCondition];
}

- (void)terminate
{
#ifdef DEBUG
    NSLog(@"%@: begin #terminate", self);
#endif
    
    shouldStop = YES;
    shouldTerminate = YES;
    
    [conditionLock lockWhenCondition:NUThreadedChildminderDeactiveCondition];
    
    if (!isTerminated)
    {
        [conditionLock unlockWithCondition:NUThreadedChildminderActiveCondition];
        [conditionLock lockWhenCondition:NUThreadedChildminderDeactiveCondition];
    }
    
    [conditionLock unlockWithCondition:NUThreadedChildminderDeactiveCondition];
    
#ifdef DEBUG
    NSLog(@"%@: end #terminate", self);
#endif
}

- (void)startThread:(id)anArgument
{
#ifdef DEBUG
    NSLog(@"%@: begin #startThread:", self);
#endif
    
    while (YES)
    {
        [conditionLock lockWhenCondition:NUThreadedChildminderActiveCondition];
        
        if (!shouldTerminate)
        {
            @autoreleasepool
            {
                [self process];
            }
        }
        else
            isTerminated = YES;
        
        [conditionLock unlockWithCondition:NUThreadedChildminderDeactiveCondition];
        
        
        if (isTerminated) break;
    }
    
#ifdef DEBUG
    NSLog(@"%@: end #startThread:", self);
#endif
}

- (void)process
{
    
}

- (BOOL)shouldStop
{
    return shouldStop;
}

- (void)setShouldStop:(BOOL)aShouldStop
{
    shouldStop = aShouldStop;
}

@end
