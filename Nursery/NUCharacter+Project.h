//
//  NUCharacter+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/29.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUCharacter.h"

@interface NUCharacter (Private)

- (void)setSuperCharacter:(NUCharacter *)aSuper;
- (void)setName:(NSString *)aName;

- (void)setIvars:(NSMutableArray *)anIvars;
- (void)setAllOOPIvars:(NSArray *)anOOPIvars;
- (void)setAllIvars:(NSArray *)anIvars;

- (void)setSubCharacters:(NSMutableSet *)aSubCharacters;
- (void)setInheritanceNameWithVersion:(NSString *)anInheritanceNameWithVersion;

@end
