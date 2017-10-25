//
//  NUNSURL.m
//  Nursery
//
//  Created by P,T,A on 2013/11/17.
//
//

#import "NUNSURL.h"
#import "NUCharacter.h"
#import "NUPlayLot.h"
#import "NUURLCoder.h"

@implementation NSURL (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
	return [self isEqual:[NSURL class]];
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    [aCharacter setIsMutable:NO];
    
    [aCharacter addOOPIvarWithName:@"absoluteURL"];
    
    [aCharacter setFormat:NUFixedIvars];
    [aCharacter setCoderClass:[NUURLCoder class]];
}

@end
