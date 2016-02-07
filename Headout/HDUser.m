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

@interface HDUser ()

@property (nonatomic, strong) NSCache *profilePicCache;
@property (nonatomic, assign) BOOL isSaveInPreogress;


@end

@implementation HDUser

- (instancetype)initWithPFUser:(PFUser*)parseUser {
    if (self = [super init]) {
        self.parseUser = parseUser;
    }
    return self;
}


- (void)setUserID:(NSString*)userID {
    if (userID) {
        [self.parseUser setObject:userID forKey:kKeyUserId];
        [[NSUserDefaults standardUserDefaults] setValue:userID forKey:kKeyUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];


    }
}

- (NSString*)userID {
    return [[NSUserDefaults  standardUserDefaults] valueForKey:kKeyUserId];
    
}



- (void)setName:(NSString*)Name {
    [self.parseUser setObject:Name forKey:kKeyName];
    [[NSUserDefaults standardUserDefaults] setValue:Name forKey:kKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString*)name {
    return [[NSUserDefaults  standardUserDefaults] valueForKey:kKeyName];
}


- (void)setEmailID:(NSString *)emailID {
    [self.parseUser setObject:emailID forKey:kEmailID];
    [[NSUserDefaults standardUserDefaults] setValue:emailID forKey:kEmailID];
    [[NSUserDefaults standardUserDefaults] synchronize];


}

- (NSString*)emailID {
    return [[NSUserDefaults  standardUserDefaults] valueForKey:kEmailID];

}

- (void)saveUser {
    if (self.isSaveInPreogress) {
        return;
    }
    
    [self.parseUser saveInBackground];
    
    __block PFObject *user = nil;
    
    if (self.emailID) {
        self.isSaveInPreogress = YES;
        
        PFQuery *query = [PFQuery queryWithClassName:@"HDUser"];
        [query whereKey:@"emailID" equalTo:self.emailID];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            if (objects.count) {
                user = [objects lastObject];
            } else {
                user = [PFObject objectWithClassName:@"HDUser"];
            }
            
            
            [self.parseUser.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                [user setObject:self.parseUser[key] forKey:key];
                
            }];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [user save];
                self.isSaveInPreogress = NO;
                
            });
        }];
        
        
    }
}

- (void)setProfilePic:(UIImage *)profilePic {
    NSData *imageData = UIImagePNGRepresentation(profilePic);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"profilePic.png"] data:imageData];
    [imageFile saveInBackground];
    self.parseUser[@"ProfilePic"] = imageFile;
    [[NSUserDefaults standardUserDefaults] setValue:imageFile.url forKey:@"ProfilePic"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.parseUser saveInBackground];
}

- (NSString *)profilePicPath {
    
    return [[NSUserDefaults  standardUserDefaults] valueForKey:@"ProfilePic"];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)deviceToken {
    return [[NSUserDefaults  standardUserDefaults] valueForKey:@"deviceToken"];
}


@end
