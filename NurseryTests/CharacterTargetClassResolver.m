//
//  CharacterTargetClassResolverForTestUpgradeCharacter.m
//  NurseryTests
//
//  Created by Akifumi Takata on 2018/06/07.
//

#import "CharacterTargetClassResolver.h"
#import "Person.h"

@implementation CharacterTargetClassResolver

- (BOOL)resolveTargetClassOrCoderForCharacter:(NUCharacter *)aCharacter onGarden:(NUGarden *)aGarden
{
    if ([[aCharacter name] isEqualToString:@"Person"])
    {
        [aCharacter setTargetClass:[Person class]];
        return YES;
    }
    
    return NO;
}

@end
