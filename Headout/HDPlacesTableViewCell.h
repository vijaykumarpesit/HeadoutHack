//
//  HDPlacesTableViewCell.h
//  Headout
//
//  Created by Karthik Ramakrishna on 2/7/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDPlacesTableViewCell;

@protocol HDPlacesTableViewCellDelegate <NSObject>

- (void)likeButtonTappedForCell:(HDPlacesTableViewCell *)cell;
- (void)dislikeButtonTappedForCell:(HDPlacesTableViewCell *)cell;

@end

@interface HDPlacesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *vicinityLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeInfoLabel;
@property (weak, nonatomic) id<HDPlacesTableViewCellDelegate> delegate;

- (void)setLikesCount:(NSInteger)count;
- (void)setDislikesCount:(NSInteger)count;

@end
