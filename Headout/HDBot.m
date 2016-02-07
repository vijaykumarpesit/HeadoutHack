//
//  HDBot.m
//  Headout
//
//  Created by Vijay on 07/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDBot.h"
#import "HDGoogleAPIFetcher.h"
#import "HDMessage.h"


@implementation HDBot

+ (void)fetchHashTag:(NSString *)hashTag onCompletion:(FetchCompletion)completion {
    [HDGoogleAPIFetcher fetchPlacesNearByOfType:hashTag onCompletion:completion];
}

+ (void)hdMessagesFromPlaces:(NSArray *)places onCompletion:(FetchCompletion)results {

    dispatch_queue_t serailQueue = dispatch_queue_create("localQueue", 0);
    NSMutableArray *placeArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *place in places) {
       
        NSString *placeID = place[@"id"];
        HDMessage *message = [[HDMessage alloc] init];
        message.placeName = place[@"name"];
        message.ratings = place[@"rating"];
        message.vicinity = place[@"vicinity"];
        message.timestamp = [NSDate date];
        [placeArray addObject:message];
        
        NSDictionary *photos = [place[@"photos"] firstObject];
        NSString *photoRef = photos[@"photo_reference"];
        message.photRef = photoRef;
        
//        dispatch_async(serailQueue, ^{
//            NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",placeID, GOOGLE_API_KEY];
//            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//            NSError* error;
//            NSDictionary* json = [NSJSONSerialization
//                                  JSONObjectWithData:data
//                                  
//                                  options:kNilOptions
//                                  error:&error];
//            
//            NSArray* details = [json objectForKey:@"results"];
//        });
        
    }
    if (results) {
        results (placeArray);
    }
}

@end
