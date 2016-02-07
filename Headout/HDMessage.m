//
//  HDMessage.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDMessage.h"
#import "HDDataManager.h"


@implementation HDMessage

- (BOOL)isIncoming {
    
    return (![[[[HDDataManager sharedManager] currentUser] emailID] isEqualToString:self.senderMailID]);
}

@end
