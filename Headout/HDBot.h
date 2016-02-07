//
//  HDBot.h
//  Headout
//
//  Created by Vijay on 07/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchCompletion)(NSArray *results);

@interface HDBot : NSObject


+ (void)fetchHashTag:(NSString *)hashTag onCompletion:(FetchCompletion)completion;
+ (NSArray *)hdMessagesFromPlaces:(NSArray *)places;
+ (void)hdMessagesFromPlaces:(NSArray *)places onCompletion:(FetchCompletion)results;
@end
