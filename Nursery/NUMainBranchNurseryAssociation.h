//
//  NUMainBranchNurseryAssociation.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUNurseryAssociation.h>
#import <Nursery/NUSandbox.h>
#import <Nursery/NUMainBranchNurseryAssociationProtocol.h>

@class NUMainBranchNursery;

extern NSString *NUDefaultMainBranchAssociation;

@interface NUMainBranchNurseryAssociation : NUNurseryAssociation <NUMainBranchNurseryAssociation, NSNetServiceDelegate>
{
    NSString *name;
    NSMutableDictionary *nurseries;
    NSNetService *netService;
}

+ (id)associationWithName:(NSString *)aName;

- (id)initWithName:(NSString *)aName;

- (NSString *)name;

- (void)open;
- (void)close;

- (void)setNursery:(NUMainBranchNursery *)aNursery forName:(NSString *)aName;
- (void)removeNurseryForName:(NSString *)aName;

@end

