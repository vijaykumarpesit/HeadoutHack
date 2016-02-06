//
//  HDDataManager.h
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDUser.h"

@interface HDDataManager : NSObject

+ (HDDataManager *)sharedManager;

@property (nonatomic, strong)  HDUser *currentUser;

@end
