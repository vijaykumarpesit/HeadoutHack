//
//  HDFBLoginHandler.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDFBLoginHandler.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "HDUser.h"
#import "HDDataManager.h"

@implementation HDFBLoginHandler

+ (void)fetchAndSaveMyInfo {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email" forKey:@"fields"];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             
             if (result) {
                 NSLog(@"%@",result);
                 HDUser *user = [[HDDataManager sharedManager] currentUser];
                 [user setEmailID:result[@"email"]];
                 [user setName:result[@"name"]];
                 [user setUserID:result[@"id"]];
                 NSString *userID = result[@"id"];
                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                     NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",userID]];
                     NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
                     UIImage *fbImage = [UIImage imageWithData:imageData];
                     [user setProfilePic:fbImage];
                     [user saveUser];
                 });
             }
             
         }];
    }
}
     
@end
