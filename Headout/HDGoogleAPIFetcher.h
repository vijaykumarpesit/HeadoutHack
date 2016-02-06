//
//  HDGoogleAPIFetcher.h
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDGoogleAPIFetcher : NSObject

+ (HDGoogleAPIFetcher *)sharedIntance;

- (void)fetchPlacesNearByOfType:(NSString *)category;

@end
