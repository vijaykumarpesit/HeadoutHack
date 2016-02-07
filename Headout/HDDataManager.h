//
//  HDDataManager.h
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDUser.h"
#import "HDMessage.h"

@interface HDDataManager : NSObject

+ (HDDataManager *)sharedManager;

+ (void)sendHDMessage:(HDMessage *)hdMessage toChat:(PFObject *)chat;

@property (nonatomic, strong)  HDUser *currentUser;

@end
