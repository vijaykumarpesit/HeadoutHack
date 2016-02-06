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
#import "AppDelegate.h"

@interface HDLoginViewController ()
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation HDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.signInButton layer] setMasksToBounds:YES];
    [[self.signInButton layer] setCornerRadius:5.0];
    self.fbLoginButton.readPermissions = @[@"public_profile",
                                           @"email",
                                           //@"user_friends",
                                           //@"user_location",@"user_events",
                                           //@"user_tagged_places"
                                           ];
    self.fbLoginButton.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIColor *color = [UIColor whiteColor];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    self.emailTextField.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.emailTextField.layer.borderWidth= 1.0f;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.passwordTextField.layer.borderWidth= 1.0f;
    
    [self.emailTextField setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3]];
    [self.passwordTextField setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
