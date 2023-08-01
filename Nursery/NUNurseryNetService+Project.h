//
//  NUNurseryNetService+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/29.
//

#import "NUNurseryNetService.h"

@class NUNurseryNetResponder, NUPupilNoteCache;


@interface NUNurseryNetService (Private)

- (NUMainBranchNursery *)nursery;
- (NUPupilNoteCache *)pupilNoteCache;

- (void)netResponderDidStop:(NUNurseryNetResponder *)sender;

@end
