//
//  CharacterTargetClassResolverForTestUpgradeCharacter.h
//  NurseryTests
//
//  Created by Akifumi Takata on 2018/06/07.
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@interface CharacterTargetClassResolver : NSObject <NUCharacterTargetClassResolving>

- (BOOL)resolveTargetClassOrCoderForCharacter:(NUCharacter *)aCharacter onGarden:(NUGarden *)aGarden;

@end
