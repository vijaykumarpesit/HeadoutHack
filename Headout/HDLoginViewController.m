//
//  ViewController.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "HDGoogleAPIFetcher.h"

@interface HDLoginViewController ()

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation HDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.readPermissions =
    @[@"public_profile",
      @"email",
      //@"user_friends",
      //@"user_location",@"user_events",
      //@"user_tagged_places"
      ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
