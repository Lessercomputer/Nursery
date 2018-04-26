//
//  NUURLCoder.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import <Foundation/NSURL.h>

#import "NUURLCoder.h"
#import "NUAliaser.h"

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
