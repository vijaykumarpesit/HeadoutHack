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
#import "HDUser.h"
#import "HDDataManager.h"

@interface HDFriendsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HDFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"reUseID"];
    
    if (self.isInFriendsMode) {
        [self loadAllFriends];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUseID"];
    if (self.isInFriendsMode) {
        HDFriendData *user = [self.dataArray objectAtIndex:indexPath.row];
        cell.name.text = user.name;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HDFriendData *data = [self.dataArray objectAtIndex:indexPath.row];
    [self.delegate didSelectHDuserData:data];
}

- (void)loadAllFriends {
    
    PFQuery *friendsQuery = [PFQuery queryWithClassName:@"HDUser"];
    
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *object in objects) {
            
            NSString *emailID = [[[HDDataManager sharedManager] currentUser] emailID];
            
            if (![object[@"emailID"] isEqualToString:emailID]) {
                HDFriendData *user = [[HDFriendData alloc] init];
                user.name = object[@"name"];
                user.emailID = object[@"emailID"];
                user.userID = object[@"userID"];
                user.profilePicPath = object[@"profilePicPath"];
                [self.dataArray addObject:user];
                
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}


@end
