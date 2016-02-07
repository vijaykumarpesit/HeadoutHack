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
#import "HDFriendsViewController.h"
#import "HDPlacesTableViewCell.h"
#import <UIImageView+WebCache.h>


@interface HDChatViewController () <UITableViewDataSource,UITableViewDelegate,UUMessageCellDelegate,UUInputFunctionViewDelegate,UITextViewDelegate,HDFriendsViewControllerDelegate,HDPlacesTableViewCellDelegate>

@property (nonatomic, strong) NSCache *avatarCache;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (strong, nonatomic)  UITableView *chatTableView;
@property (nonatomic, strong) UUInputFunctionView *chatToolBar;
@property (nonatomic, strong)  HDFriendsViewController*friendsTableVC;
@property (nonatomic, strong) HDFriendsViewController *categoriesTableVC;
@property (nonatomic, assign) CGRect kyFrame;
@property (nonatomic, assign) BOOL isBottomTablePopulated;
@property (nonatomic, strong) HDChat *chat;
@end

@implementation HDChatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.chatTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.chatTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.chatTableView];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadAllMessages];
    self.avatarCache = [[NSCache alloc] init];
    //[self loadDummyData];
    [self.chatTableView setDelegate:self];
    [self.chatTableView setDataSource:self];
    [self loadBaseViewsAndData];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    
    self.friendsTableVC = [[HDFriendsViewController alloc] initWithNibName:nil bundle:nil];
    self.friendsTableVC.delegate = self;
    self.friendsTableVC.isInFriendsMode = YES;
    //Load the view
    [self.friendsTableVC view];
    [self.chatTableView registerNib:[UINib nibWithNibName:@"HDPlacesTableViewCell" bundle:nil] forCellReuseIdentifier:@"placesCell"];
//    
//    NSString *chatID =  [[NSUserDefaults standardUserDefaults] valueForKey:@"chatID"];
//    if (chatID) {
//        self.chatIdentifier = chatID;
//    } else {
//        self.chatIdentifier = [self GetUUID];
//        [[NSUserDefaults standardUserDefaults] setValue:self.chatIdentifier forKey:@"chatID"];
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self createAndSyncChataIfNeeded];
}

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.chatTableView.frame = CGRectMake(0, 0,self.view.bounds.size.width , self.view.bounds.size.height-55);
    self.friendsTableVC.view.frame = CGRectMake(CGRectGetMinX(self.chatTableView.frame), CGRectGetMaxY(self.chatTableView.frame),self.friendsTableVC.view.bounds.size.width , self.friendsTableVC.view.bounds.size.height);
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

- (void)createAndSyncChataIfNeeded {
    
    PFQuery *query = [PFQuery queryWithClassName:@"HDChat"];
    [query whereKey:@"identifier" equalTo:self.chatIdentifier];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        __block PFObject *chat = nil;
        if (objects.count) {
            chat = [objects lastObject];
        } else {
            chat = [PFObject objectWithClassName:@"HDChat"];
        }
        HDChat *localChat = [[HDChat alloc] init];
        localChat.identifier = chat[@"identifier"];
        localChat.partcipants = chat[@"participants"];
        localChat.pfChat = chat;
        localChat.identifier = self.chatIdentifier;
        self.chat = localChat;
        NSArray *messages = chat[@"messages"];
        
        dispatch_queue_t serailQueue = dispatch_queue_create("syncQueue", 0);
        
        for (PFObject *messageObjectID in messages) {
            PFQuery *messageQuery=[PFQuery queryWithClassName:@"message"];
            [messageQuery whereKey:@"objectId" equalTo:messageObjectID.objectId];
            dispatch_async(serailQueue, ^{
                PFObject *message = [messageQuery getFirstObject];
                if (message) {
                    HDMessage *localMessage = [[HDMessage alloc] init];
                    localMessage.senderID = message[@"senderID"];
                    localMessage.senderMailID = message[@"senderMailID"];
                    localMessage.senderName = message[@"senderName"];
                    localMessage.timestamp = message[@"timestamp"];
                    localMessage.text = message[@"text"];
                    localMessage.filePath = message[@"filePath"];
                    localMessage.likedUsers = message[@"likedUsers"];
                    localMessage.disLikedUsers = message[@"disLikedUsers"];
                    localMessage.placeName = message[@"placeName"];
                    localMessage.ratings = message[@"rating"];
                    localMessage. vicinity = message[@"vicinity"];
                    localMessage.photRef = message[@"photRef"];
                    [localChat.messages addObject:localMessage];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.chatTableView reloadData];
                    });
 
                }
                
            });
            
            
        }
        chat[@"identifier"] = self.chatIdentifier;
        NSString *emailID = [[[HDDataManager sharedManager] currentUser] emailID];
        chat[@"participants"] = @[];
        [chat saveInBackground];
    }];
    
    
}

- (void)loadBaseViewsAndData
{
    self.chatToolBar = [[UUInputFunctionView alloc]initWithSuperVC:self];
    self.chatToolBar.delegate = self;
    [self.chatToolBar.btnVoiceRecord removeFromSuperview];
    [self.chatToolBar.btnChangeVoiceState removeFromSuperview];

    [self.view addSubview:self.chatToolBar];
    
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

- (void)tableViewScrollToBottom
{
    if (self.chat.messages.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chat.messages.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)loadDummyData {
    
//    for (int i =0; i< 10; i ++) {
//        HDMessage *message = [[HDMessage alloc] init];
//        message.text = @"Vijay";
//        message.timestamp = [NSDate date];
//        message.senderName = @"Dummy";
//        message.isIncoming = NO;
//        [self.messages addObject:message];
//    }
    
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
    self.kyFrame = keyboardEndFrame;
    
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
    return self.chat.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDMessage *hdMessage = [self.chat.messages objectAtIndex:indexPath.row];
    if (!hdMessage.placeName) {
        UUMessageFrame * messageFrame = [[UUMessageFrame alloc] init];
        UUMessage *message = [[UUMessage alloc] init];
        //Change this profile pic depending on sender
        NSString *profilePicPath = [[[HDDataManager sharedManager] currentUser] profilePicPath];
        if (profilePicPath) {
            message.strIcon = profilePicPath;
        } else {
            message.strIcon = @"";
        }
        if (hdMessage.senderID) {
            message.strId = hdMessage.senderID;
            
        }
        NSString *dateString = [NSDateFormatter localizedStringFromDate:hdMessage.timestamp
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterFullStyle];
        message.strTime = dateString;
        message.strName = hdMessage.senderName;
        message.strContent = hdMessage.text;

        if ([hdMessage isIncoming]) {
            message.from = UUMessageFromOther;
        } else {
            message.from = UUMessageFromMe;
        }

        [messageFrame setMessage:message];
        
        UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        if (cell == nil) {
            cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
            cell.delegate = self;
        }
        
        [cell setMessageFrame:messageFrame];
        return cell;
    } else {
        HDPlacesTableViewCell *placesCell = [tableView dequeueReusableCellWithIdentifier:@"placesCell"];
        if (!placesCell) {
            placesCell = [[HDPlacesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCellID"];
        }
        [placesCell.placeImageView sd_setImageWithURL:[NSURL URLWithString:[hdMessage photoURL]] placeholderImage:[UIImage imageNamed:@"quota.png"]];
        placesCell.infoLabel.text = hdMessage.placeName;
        [placesCell setLikesCount:hdMessage.likedUsers.count];
        [placesCell setDislikesCount:hdMessage.disLikedUsers.count];
        placesCell.delegate = self;
        
        return placesCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDMessage *hdMessage = [self.chat.messages objectAtIndex:indexPath.row];
    if (!hdMessage.placeName) {
        UUMessage *message = [[UUMessage alloc] init];
        UUMessageFrame * messageFrame = [[UUMessageFrame alloc] init];
        [messageFrame setMessage:message];
        return [messageFrame cellHeight];
    } else {
        return 200;
    }
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
                     
                     for (HDMessage *hdMessage in results) {
                         [HDDataManager sendHDMessage:hdMessage toChat:self.chat.pfChat];
                         [self.chat.messages addObject:hdMessage];
                         [self.chatTableView reloadData];
                         //[self tableViewScrollToBottom];


                     }
                 }];

             }
             
         }];
     }
    
    if (message.length > 0) {
        [self sendMessageWithText:message];
    }
    
    //[[StateMachineManager sharedInstance] userRepliedWithText:message];
}

- (void)sendMessageWithText:(NSString *)text {
    HDMessage *hdMessage = [[HDMessage alloc] init];
    hdMessage.text = text;
    hdMessage.senderID = [[[HDDataManager sharedManager] currentUser] userID];
    hdMessage.senderName = [[[HDDataManager sharedManager] currentUser] name];
    hdMessage.senderMailID = [[[HDDataManager sharedManager] currentUser] emailID];
    hdMessage.timestamp = [NSDate date];
    [self.chat.messages addObject:hdMessage];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    self.chatToolBar.TextViewInput.text = @"";

    [HDDataManager sendHDMessage:hdMessage toChat:self.chat.pfChat];

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
        [self populateSearchTable];
    } else if ([textView.text isEqualToString:@""] && self.isBottomTablePopulated) {
        [self removeSearchTable];
    }
}

//We need to aniamte this
- (void)populateSearchTable {

    if (!self.isBottomTablePopulated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self.view addSubview:self.friendsTableVC.view];
            [self.friendsTableVC.view setFrame:CGRectMake(0, self.kyFrame.origin.y - 55 - 90, self.view.bounds.size.width, 90)];
        } completion:^(BOOL finished) {
            self.isBottomTablePopulated = YES;
        }];
    }
}

- (void)didSelectHDuserData:(HDFriendData *)friendData {
    [self removeSearchTable];
    [self.friendsTableVC reloadFriendList];

    NSString *text = [NSString stringWithFormat:@"You added %@ to group",friendData.name];
    [self sendMessageWithText:text];
    
    NSArray *array =  self.chat.pfChat[@"partcipants"];
    NSMutableArray *updatedArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:friendData.userID forKey:@"userID"];
    [userDict setValue:friendData.name forKey:@"name"];
    [userDict setValue:friendData.emailID forKey:@"emailID"];
    [userDict setValue:friendData.profilePicPath forKey:@"profilePicPath"];
    [userDict setValue:friendData.deviceToken forKey:@"deviceToken"];
    
    
    if (array) {
        [updatedArray addObjectsFromArray:array];
    }
    self.chat.pfChat[@"partcipants"] = updatedArray;
    [self.chat.pfChat saveInBackground];
    

    
    // Send push notification to query
    NSString *deviceToken = friendData.deviceToken;
    if (deviceToken) {
        PFQuery *query = [PFQuery queryWithClassName:@"SubscribeService"];
        [query whereKey:@"deviceToken" equalTo:deviceToken];
        [PFPush sendPushMessageToQuery:query withMessage: [NSString stringWithFormat:@"chat%@",self.chatIdentifier] error:nil];
    }
}

- (void)removeSearchTable {
    if (self.isBottomTablePopulated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.friendsTableVC.view.frame = CGRectMake(CGRectGetMinX(self.chatTableView.frame), CGRectGetMaxY(self.chatTableView.frame),self.friendsTableVC.view.bounds.size.width , self.friendsTableVC.view.bounds.size.height-55);
        } completion:^(BOOL finished) {
            [self.friendsTableVC.view removeFromSuperview];
            self.isBottomTablePopulated = NO;
        }];
    }
}

- (void)likeButtonTappedForCell:(HDPlacesTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.chatTableView indexPathForCell:cell];
    HDMessage *hdMessage = [self.chat.messages objectAtIndex:indexPath.row];

    
}

- (void)dislikeButtonTappedForCell:(HDPlacesTableViewCell *)cell
{
    
}

- (void)updateChatWithId:(NSString *)chatID {
    if (self.chatIdentifier && self.chat.messages.count) {
        HDMessage *lastMessage = [self.chat.messages lastObject];
        PFQuery *latestChanges = [PFQuery queryWithClassName:@"message"];
        [latestChanges whereKey:@"updatedAt" greaterThan:lastMessage.timestamp];
        
        [latestChanges findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            for(PFObject *message in objects) {
                if (message) {
                    HDMessage *localMessage = [[HDMessage alloc] init];
                    localMessage.senderID = message[@"senderID"];
                    localMessage.senderMailID = message[@"senderMailID"];
                    localMessage.senderName = message[@"senderName"];
                    localMessage.timestamp = message[@"timestamp"];
                    localMessage.text = message[@"text"];
                    localMessage.filePath = message[@"filePath"];
                    localMessage.likedUsers = message[@"likedUsers"];
                    localMessage.disLikedUsers = message[@"disLikedUsers"];
                    localMessage.placeName = message[@"placeName"];
                    localMessage.ratings = message[@"rating"];
                    localMessage. vicinity = message[@"vicinity"];
                    localMessage.photRef = message[@"photRef"];
                    [self.chat.messages addObject:localMessage];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.chatTableView reloadData];
                    });
                }
            }
            
        }];
        
        
    } else {
        self.chatIdentifier = chatID;
        [self createAndSyncChataIfNeeded];
    }
}

- (void)updateMessageWithID:(NSString *)messageID {
    
    PFQuery *latestChanges = [PFQuery queryWithClassName:@"message"];
    [latestChanges whereKey:@"objectId" greaterThan:messageID];
    [latestChanges findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        PFObject *message = [objects firstObject];
        if (message) {
            HDMessage *localMessage = [[HDMessage alloc] init];
            localMessage.senderID = message[@"senderID"];
            localMessage.senderMailID = message[@"senderMailID"];
            localMessage.senderName = message[@"senderName"];
            localMessage.timestamp = message[@"timestamp"];
            localMessage.text = message[@"text"];
            localMessage.filePath = message[@"filePath"];
            localMessage.likedUsers = message[@"likedUsers"];
            localMessage.disLikedUsers = message[@"disLikedUsers"];
            localMessage.placeName = message[@"placeName"];
            localMessage.ratings = message[@"rating"];
            localMessage. vicinity = message[@"vicinity"];
            localMessage.photRef = message[@"photRef"];
            [self.chat.messages addObject:localMessage];
        }
        
    }];
    
}

@end
