//
//  AppDelegate.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "HDGoogleAPIFetcher.h"
#import "HDFBLoginHandler.h"
#import <Parse/Parse.h>
#import "HDLoginViewController.h"
#import "HDChatViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface AppDelegate () <FBSDKLoginButtonDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [HDGoogleAPIFetcher sharedIntance];
    
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"hp6k2Z0QPtjYvEs71fR8x9MYtyLazTsDgsZG8DZO"
                  clientKey:@"uIaegiayIkDJsaMkZ7RiRw8i6odqBODe4aL6cwtX"];
    
    [self configureRootVC];
    return YES;
}


- (void)configureRootVC {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];


    
    if([FBSDKAccessToken currentAccessToken]) {
        UINavigationController *chatNavVC = [storyboard instantiateViewControllerWithIdentifier:@"chatNavVC"];
        [self.window setRootViewController:chatNavVC];
    
    } else {
        HDLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self.window setRootViewController:loginVC];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void) loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
               error:(NSError *)error {
    
    if (!error &&result.token) {
        [self configureRootVC];
        [HDFBLoginHandler fetchAndSaveMyInfo];
    }
}

@end
