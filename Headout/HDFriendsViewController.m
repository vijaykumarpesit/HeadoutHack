//
//  HDFriendsViewController.m
//  Headout
//
//  Created by Vijay on 07/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDFriendsViewController.h"
#import "FriendsCell.h"
#import "HDFriendData.h"

@interface HDFriendsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HDFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.dataArray = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"reUseID"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUseID"];
    HDFriendData *friendData = [self.dataArray objectAtIndex:indexPath.row];
    cell.name.text = friendData.name;
    return cell;
}

- (void)loadAllFriends {
    
    PFQuery *friendsQuery = [PFQuery queryWithClassName:@"HDUser"];
    
        [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
            
    
        }];
    
}

@end
