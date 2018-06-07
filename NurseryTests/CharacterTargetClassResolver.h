//
//  CharacterTargetClassResolverForTestUpgradeCharacter.h
//  NurseryTests
//
//  Created by Akifumi Takata on 2018/06/07.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@interface CharacterTargetClassResolver : NSObject <NUCharacterTargetClassResolving>

- (BOOL)resolveTargetClassOrCoderForCharacter:(NUCharacter *)aCharacter onGarden:(NUGarden *)aGarden;

@end
