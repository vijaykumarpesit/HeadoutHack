//
//  HDUser.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDUser.h"


NSString * const kKeyUserId = @"userID";
NSString * const kKeyName = @"name";
NSString * const kEmailID = @"emailID";
NSString * const kProfilePic = @"profilePic";

@implementation HDUser

- (instancetype)initWithPFUser:(PFUser*)parseUser {
    if (self = [super init]) {
        self.parseUser = parseUser;
    }
    return self;
}


- (void)setUserID:(NSString*)userID {
    [self.parseUser setObject:userID forKey:kKeyUserId];
}

- (NSString*)userID {
    return [self.parseUser objectForKey:kKeyUserId];
}



- (void)setName:(NSString*)Name {
    [self.parseUser setObject:Name forKey:kKeyName];
}

- (NSString*)name {
    return [self.parseUser objectForKey:kKeyName];
}


- (void)setEmailID:(NSString *)emailID {
    [self.parseUser setObject:emailID forKey:kEmailID];
}

- (NSString*)emailID {
    return [self.parseUser objectForKey:kEmailID];
}

- (void)saveUser {
    [self.parseUser saveInBackground];
}


@end
