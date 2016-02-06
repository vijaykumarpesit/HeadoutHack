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
    }
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
    [self.parseUser saveInBackground];
}

- (NSString *)profilePicPath {
    
    PFFile *imageFile = self.parseUser[@"ProfilePic"];
    return  imageFile.url;
}

@end
