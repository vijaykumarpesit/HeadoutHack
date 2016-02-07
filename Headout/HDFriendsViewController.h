//
//  HDFriendsViewController.h
//  Headout
//
//  Created by Vijay on 07/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDFriendData.h"

@protocol HDFriendsViewControllerDelegate <NSObject>

- (void)didSelectHDuserData:(HDFriendData *)friendData;

@end

@interface HDFriendsViewController : UIViewController

@property (nonatomic, assign) BOOL isInFriendsMode;

@property (nonatomic, weak) id <HDFriendsViewControllerDelegate> delegate;

- (void)reloadFriendList;

@end
