//
//  HDMessage.h
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDMessage : NSObject

@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *senderMailID;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL isIncoming;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSArray *likedUsers;
@property (nonatomic, strong) NSArray *disLikedUsers;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *ratings;
@property (nonatomic, strong) NSString *vicinity;
@property (nonatomic,strong) NSString *objectID;

//Convert thsi in to google phot ref like this 
//https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU&key=YOUR_API_KEY//
@property (nonatomic, strong) NSString *photRef;
- (NSString *)photoURL;
@end
