//
//  NUDateCoder.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import "NUDateCoder.h"
#import "NUAliaser.h"

@implementation NUDateCoder

- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
	NSDate *aDate = anObject;
	[anAliaser encodeDouble:[aDate timeIntervalSinceReferenceDate]];
}

- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser
{
	return [NSDate dateWithTimeIntervalSinceReferenceDate:[anAliaser decodeDouble]];
}

@end
