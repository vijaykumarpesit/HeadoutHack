//
//  HDGoogleAPIFetcher.h
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef void (^FetchCompletion)(NSArray *results);

@interface HDGoogleAPIFetcher : NSObject

@property(nonatomic, strong) CLLocationManager *locationManager;


+ (HDGoogleAPIFetcher *)sharedIntance;

+ (void)fetchPlacesNearByOfType:(NSString *)category onCompletion:(FetchCompletion)completion;

@end
