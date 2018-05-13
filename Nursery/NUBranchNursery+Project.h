//
//  NUBranchNursery+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/28.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUBranchNursery.h"

@interface NUBranchNursery (Private)

- (NUNurseryNetClient *)netClient;
- (void)setNetClient:(NUNurseryNetClient *)aNetClient;

- (NUPupilNoteCache *)pupilNoteCache;
- (void)setPupilNoteCache:(NUPupilNoteCache *)aPupilNoteCache;

@end
