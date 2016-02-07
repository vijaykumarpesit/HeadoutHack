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

- (NSString *)photoURL {
    return [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@=%@",self.photRef,GOOGLE_API_KEY];
}

@end
