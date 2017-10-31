//
//  NUNSURL.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import "NUNSURL.h"
#import "NUCharacter.h"
#import "NUSandbox.h"
#import "NUURLCoder.h"

@implementation NSURL (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
	return [self isEqual:[NSURL class]];
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
{
    [aCharacter setIsMutable:NO];
    
    [aCharacter addOOPIvarWithName:@"absoluteURL"];
    
    [aCharacter setFormat:NUFixedIvars];
    [aCharacter setCoderClass:[NUURLCoder class]];
}

@end
