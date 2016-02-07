//
//  HDChat.h
//  Headout
//
//  Created by Vijay on 07/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDChat : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSMutableSet *partcipants;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) PFObject *pfChat;
@end
