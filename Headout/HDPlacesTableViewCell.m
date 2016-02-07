//
//  HDPlacesTableViewCell.m
//  Headout
//
//  Created by Karthik Ramakrishna on 2/7/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDPlacesTableViewCell.h"

@interface HDPlacesTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dislikesCountLabel;

@end

@implementation HDPlacesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(likeButtonTappedForCell:)]) {
        [self.delegate likeButtonTappedForCell:self];
    }
}

- (IBAction)dislikeButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dislikeButtonTappedForCell:)]) {
        [self.delegate dislikeButtonTappedForCell:self];
    }
}

- (void)setLikesCount:(NSInteger)count
{
    self.likesCountLabel.text = [@(count) stringValue];
}

-(void)setDislikesCount:(NSInteger)count
{
    self.dislikesCountLabel.text = [@(count) stringValue];
}

@end
