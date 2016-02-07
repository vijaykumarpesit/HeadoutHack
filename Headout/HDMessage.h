//
//  HDMessage.h
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDMessage : NSObject

@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL isIncoming;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSSet *likedUsers;
@property (nonatomic, strong) NSSet *disLikedUsers;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *ratings;
@end
