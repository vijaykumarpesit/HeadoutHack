//
//  HDUser.h
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface HDUser : NSObject

@property (nonatomic, strong)PFUser *parseUser;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *emailID;
@property (nonatomic, copy) NSString *profilePicPath;
@property (nonatomic, copy) NSString *deviceToken;

- (instancetype)initWithPFUser:(PFUser*)parseUser;
- (void)saveUser;
- (void)setProfilePic:(UIImage *)profilePic;


@end
