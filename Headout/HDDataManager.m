//
//  HDDataManager.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDDataManager.h"
#import "HDMessage.h"
#import "HDChat.h"

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

+ (void)sendHDMessage:(HDMessage *)hdMessage toChat:(PFObject *)chat{
    
    PFObject *message = [PFObject objectWithClassName:@"message"];
    if (hdMessage.senderID) {
        message[@"senderID"] = hdMessage.senderID;
    }
    
    if (hdMessage.senderName) {
        message[@"senderName"] = hdMessage.senderName;
    }
    
    if (hdMessage.timestamp) {
        message[@"timestamp"] = hdMessage.timestamp;
    }
    
    if (hdMessage.senderMailID) {
        message[@"senderMailID"] = hdMessage.senderMailID;
    }
    if (hdMessage.text) {
        message[@"text"] = hdMessage.text;
    }
    
    if (hdMessage.filePath) {
        message[@"filePath"] = hdMessage.filePath;
    }
    if (hdMessage.likedUsers.count) {
        message[@"likedUsers"] = hdMessage.likedUsers;
    }
    if (hdMessage.disLikedUsers.count) {
        message[@"disLikedUsers"] = hdMessage.disLikedUsers;
    }
    
    if (hdMessage.placeName) {
        message[@"placeName"] = hdMessage.placeName;
    }
    
    if (hdMessage.ratings) {
        message[@"ratings"] = hdMessage.ratings;
    }
    
    if (hdMessage.vicinity) {
        message[@"vicinity"] = hdMessage.vicinity;
    }
    
    [message saveInBackground];
    
    NSArray *messages = nil;
    NSMutableArray *updatedMessages = [[NSMutableArray alloc] init];
    
    if (chat[@"messages"]) {
        messages = chat[@"messages"];
        [updatedMessages addObjectsFromArray:messages];
    }
    
    [updatedMessages addObject:message];
    chat[@"messages"] = updatedMessages;
    [chat saveInBackground];
}

@end
