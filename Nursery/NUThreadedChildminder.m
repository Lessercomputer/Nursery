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
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(startThread:) object:nil];
    }
    
	return self;
}

- (void)dealloc
{
    [self setGarden:nil];

	[thread release];
	
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

- (double)threadPriority
{
    return 0.0;
}

- (void)start
{
    [thread setName:[self threadName]];
    [thread setThreadPriority:[self threadPriority]];
    [thread start];
}

- (void)stop
{
    [thread cancel];
}

- (void)startThread:(id)anArgument
{
    while (![thread isCancelled])
    {
        @autoreleasepool
        {
            [self processOneUnit];
        }
    }
}

- (void)processOneUnit
{
}

@end
