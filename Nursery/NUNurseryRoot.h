//
//  NUNurseryRoot.h
//  Nursery
//
//  Created by P,T,A on 11/07/14.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUCoding.h>
#import <Nursery/NUMovingUp.h>

@class NUCharacterDictionary, NUBell;

@interface NUNurseryRoot : NSObject <NUCoding, NUMovingUp>
{
	NUCharacterDictionary *characters;
	id userRoot;
	NUBell *bell;
}

+ (id)root;

- (void)decodeIvarsWithAliaser:(NUAliaser *)anAliaser;

@end

@interface NUNurseryRoot (Accessing)

- (NUCharacterDictionary *)characters;
- (void)setCharacters:(NUCharacterDictionary *)aCharacters;

- (id)userRoot;
- (void)setUserRoot:(id)aRoot;

@end

@interface NUNurseryRoot (MoveUp)

- (void)moveUp;
- (void)moveUpCharacters;

@end
