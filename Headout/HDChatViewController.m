//
//  HDChatViewController.m
//  Headout
//
//  Created by Vijay on 06/02/16.
//  Copyright © 2016 Hackthon. All rights reserved.
//

#import "HDChatViewController.h"
#import "HDMessage.h"
#import "HDDataManager.h"
#import "HDMessageData.h"
#import "UUMessage.h"
#import "UUMessageCell.h"
#import "UUMessageFrame.h"
#import "UUInputFunctionView.h"


@interface HDChatViewController () <UITableViewDataSource,UITableViewDelegate,UUMessageCellDelegate,UUInputFunctionViewDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSCache *avatarCache;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (strong, nonatomic)  UITableView *chatTableView;
@property (nonatomic, strong) UUInputFunctionView *IFView;

@end

@implementation HDChatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.chatTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.chatTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.chatTableView];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadAllMessages];
    self.messages = [[NSMutableArray alloc] init];
    self.avatarCache = [[NSCache alloc] init];
    [self loadDummyData];
    [self.chatTableView setDelegate:self];
    [self.chatTableView setDataSource:self];
    [self loadBaseViewsAndData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAllMessages {
    
    PFQuery *messagesQuery = [PFQuery queryWithClassName:@"Messages"];
    
//    [messagesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        self.messages = [objects mutableCopy];
//        [self.collectionView reloadData];
//    }];
//    
}


- (void)loadBaseViewsAndData
{
    self.IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    self.IFView.delegate = self;
    [self.view addSubview:self.IFView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

- (void)tableViewScrollToBottom
{
    if (self.messages.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)loadDummyData {
    
    for (int i =0; i< 10; i ++) {
        HDMessage *message = [[HDMessage alloc] init];
        message.text = @"Vijay";
        message.timestamp = [NSDate date];
        message.senderName = @"Dummy";
        message.isIncoming = NO;
        [self.messages addObject:message];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    
    HDMessage *hdMessage = [self.messages objectAtIndex:indexPath.row];
    UUMessageFrame * messageFrame = [[UUMessageFrame alloc] init];
    UUMessage *message = [[UUMessage alloc] init];
    message.strIcon = @"";
     message.strId = hdMessage.senderID;
    //message.strTime = hdMessage.timestamp;
    message.strName = hdMessage.senderName;
    message.strContent = hdMessage.text;
    [messageFrame setMessage:message];
    [cell setMessageFrame:messageFrame];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UUMessage *message = [[UUMessage alloc] init];
    UUMessageFrame * messageFrame = [[UUMessageFrame alloc] init];
    [messageFrame setMessage:message];
    return [messageFrame cellHeight];
}

#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    if (message.length > 0) {
        HDMessage *hdMessage = [[HDMessage alloc] init];
        hdMessage.text = message;
        hdMessage.senderID = [[[HDDataManager sharedManager] currentUser] userID];
        hdMessage.senderName = [[[HDDataManager sharedManager] currentUser] name];
        funcView.TextViewInput.text = @"";
        [self.messages addObject:hdMessage];
        [self.chatTableView reloadData];
        [self tableViewScrollToBottom];
    }
    
    //[[StateMachineManager sharedInstance] userRepliedWithText:message];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": UIImageJPEGRepresentation(image, 1.0),
                          @"type": @(UUMessageTypePicture)};
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
}


@end
