//
//  HDGoogleAPIFetcher.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDGoogleAPIFetcher.h"
#import <CoreLocation/CoreLocation.h>

@interface HDGoogleAPIFetcher () <CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocation *currentLocation;

@end

@implementation HDGoogleAPIFetcher

+ (HDGoogleAPIFetcher *)sharedIntance {
    static HDGoogleAPIFetcher *fetcher = nil;
    static dispatch_once_t onceToken;
    
    if (!fetcher) {
        dispatch_once(&onceToken, ^{
            fetcher = [[HDGoogleAPIFetcher alloc] init];
        });
    }
    return fetcher;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        [self CurrentLocationIdentifier];
    }
    return self;
}

-(void)CurrentLocationIdentifier
{
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

//If needed then only keep updating location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations objectAtIndex:0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             NSLog(@"\nCurrent Location Detected\n");
//             NSLog(@"placemark %@",placemark);
//             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//             NSString *Address = [[NSString alloc]initWithString:locatedAt];
//             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
//             NSString *Country = [[NSString alloc]initWithString:placemark.country];
//             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
//             NSLog(@"%@",CountryArea);
         }
         else
         {
            // NSLog(@"Geocode failed with error %@", error);
             //NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

+ (void)fetchPlacesNearByOfType:(NSString *)category onCompletion:(FetchCompletion)completion{
    
    CLLocation  *location = [[HDGoogleAPIFetcher sharedIntance] currentLocation];
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", location.coordinate.latitude, location.coordinate.longitude, [NSString stringWithFormat:@"%i", 5000], category, GOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        NSError* error;
        if (data) {
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  
                                  options:kNilOptions
                                  error:&error];
            
            //The results from Google will be an array obtained from the NSDictionary object with the key "results".
            NSArray* places = [json objectForKey:@"results"];
            
            if (completion) {
                completion(places);
            }
        }
       
    });
}


-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    
    

}
@end
