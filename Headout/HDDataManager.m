//
//  HDDataManager.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDDataManager.h"

@implementation HDDataManager

+ (HDDataManager *)sharedManager {
    static HDDataManager* sharedModelManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedModelManager = [[HDDataManager alloc] init];
    });
    
    return sharedModelManager;
}

-(instancetype)init {
    if(self = [super init]) {
        PFUser *parseUser = [PFUser currentUser];
        if (!parseUser) {
            parseUser = [PFUser user];
        }
        self.currentUser = [[HDUser alloc] initWithPFUser:parseUser];
    }
    
    return self;
}

@end
