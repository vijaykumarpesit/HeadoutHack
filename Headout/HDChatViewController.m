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
#import "HDBot.h"


@interface HDChatViewController () <UITableViewDataSource,UITableViewDelegate,UUMessageCellDelegate,UUInputFunctionViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSCache *avatarCache;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (strong, nonatomic)  UITableView *chatTableView;
@property (nonatomic, strong) UUInputFunctionView *chatToolBar;

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
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.chatTableView.frame = CGRectMake(0, 0,self.view.bounds.size.width , self.view.bounds.size.height-55);

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
    self.chatToolBar = [[UUInputFunctionView alloc]initWithSuperVC:self];
    self.chatToolBar.delegate = self;
    [self.view addSubview:self.chatToolBar];
    
    
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

-(void)keyboardChange:(NSNotification *)notification
{
    if (self.navigationController.visibleViewController != self) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.chatTableView.frame = CGRectMake(0, 0,self.chatTableView.frame.size.width , self.view.bounds.size.height -55-keyboardEndFrame.size.height);
        CGRect newFrame = self.chatToolBar.frame;
        newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
        self.chatToolBar.frame = newFrame;
    }else{
        self.chatTableView.frame = CGRectMake(0, 0, self.chatTableView.frame.size.width, self.view.bounds.size.height -55);
    }
    [UIView commitAnimations];
    
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
    //Change this profile pic depending on sender
    NSString *profilePicPath = [[[HDDataManager sharedManager] currentUser] profilePicPath];
    if (profilePicPath) {
        message.strIcon = profilePicPath;
    } else {
        message.strIcon = @"";
    }
    message.strId = hdMessage.senderID;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:hdMessage.timestamp
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    message.strTime = dateString;
    message.strName = hdMessage.senderName;
    message.strContent = hdMessage.text;
    message.from = UUMessageFromOther;
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
     if (message.length > 0 && [[message substringToIndex:1] isEqualToString:@"#"]) {
         NSString *category = [message substringFromIndex:1];
         
         [HDBot fetchHashTag:category onCompletion:^(NSArray *results) {
             if (results.count > 5) {
                 NSMutableArray *topFive = [NSMutableArray arrayWithArray:[results subarrayWithRange:NSMakeRange(0, 5)]];
                 [HDBot hdMessagesFromPlaces:topFive onCompletion:^(NSArray *results) {
                     
                 }];

             }
             
         }];
     }
    
    if (message.length > 0) {
        HDMessage *hdMessage = [[HDMessage alloc] init];
        hdMessage.text = message;
        hdMessage.senderID = [[[HDDataManager sharedManager] currentUser] userID];
        hdMessage.senderName = [[[HDDataManager sharedManager] currentUser] name];
        hdMessage.timestamp = [NSDate date];
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

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView textDidChange:(UITextView *)textView {

    if ([textView.text isEqualToString:@"@"]) {
        //Populate small table
    }
}

@end
