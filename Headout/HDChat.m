//
//  HDChat.m
//  Headout
//
//  Created by Vijay on 07/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDChat.h"

@implementation HDChat


- (instancetype) init {
    
    self = [super init];
    if (self) {
        self.messages = [[NSMutableArray alloc] init];
        self.partcipants = [[NSMutableSet alloc] init];
    }
    return self;
}

@end

