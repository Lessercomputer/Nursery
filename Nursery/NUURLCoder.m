//
//  NUURLCoder.m
//  Nursery
//
//  Created by P,T,A on 2013/11/17.
//
//

#import "NUURLCoder.h"

@implementation NUURLCoder : NUCoder

- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
	NSURL *aURL = anObject;
	[anAliaser encodeObject:[aURL absoluteString]];
}

- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser
{
	return [NSURL URLWithString:[anAliaser decodeObjectReally]];
}

@end