//
//  NUBranchNursery+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/28.
//

#import "NUBranchNursery.h"

@interface NUBranchNursery (Private)

- (void)setServiceName:(NSString *)aServiceName;

- (NUPupilNoteCache *)pupilNoteCache;
- (void)setPupilNoteCache:(NUPupilNoteCache *)aPupilNoteCache;

@end
