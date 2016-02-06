//
//  HDMessageData.h
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessageData.h"
#import "HDMessage.h"

@interface HDMessageData : NSObject <JSQMessageData>

@property (nonatomic, strong) HDMessage *message;

@end
