//
//  HDMessageData.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDMessageData.h"

@implementation HDMessageData

- (NSString *)text {
    
    return self.message.text;
}

- (NSString *)sender {
    
   return self.message.senderName;
}


- (NSDate *)date {
    return self.message.timestamp;
}

@end
