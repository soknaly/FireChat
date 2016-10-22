//
//  FCMessagesViewController.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCMessagesViewController.h"
#import "JSQMessage.h"
#import "JSQMessagesBubbleImage.h"
#import "JSQMessagesBubbleImageFactory.h"

static NSString * const kJSQDemoAvatarDisplayNameDuke = @"Duke";
static NSString * const kJSQDemoAvatarDisplayNameSokna = @"Sokna Ly";

static NSString * const kJSQDemoAvatarIdDuke = @"053496-4509-289";
static NSString * const kJSQDemoAvatarIdSokna = @"707-8956784-57";

@interface FCMessagesViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) NSArray<JSQMessage *>* messages;

@property (nonatomic, strong) NSDictionary<NSString *,NSString *>* images;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation FCMessagesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.chat.fullName;
  self.senderId = kJSQDemoAvatarIdSokna;
  self.images = @{kJSQDemoAvatarIdDuke:@"https://scontent-hkg3-1.xx.fbcdn.net/v/t1.0-9/14485073_10208554229386265_902072082399694097_n.jpg?oh=2b3d043938c47b7edf48a602147fbd0d&oe=589FB5A9",
                  kJSQDemoAvatarIdSokna:@"https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/5/005/088/08a/0b388f2.jpg"};
  self.senderDisplayName = kJSQDemoAvatarDisplayNameSokna;
  JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
  self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor messageBubbleLightGrayColor]];
  self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor mainColor]];
  [self setupMockData];
}

- (void)setupMockData {
  self.messages = [[NSMutableArray alloc] initWithObjects:
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdDuke
                                      senderDisplayName:kJSQDemoAvatarDisplayNameDuke
                                                   date:[NSDate distantPast]
                                                   text:@"Hey bro!"],
                   
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdDuke
                                      senderDisplayName:kJSQDemoAvatarDisplayNameDuke
                                                   date:[NSDate distantPast]
                                                   text:@"Are you going to join GDG DevFest Cambodia 2016?"],
                   
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSokna
                                      senderDisplayName:kJSQDemoAvatarIdSokna
                                                   date:[NSDate distantPast]
                                                   text:@"Hi bro!"],
                   
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSokna
                                      senderDisplayName:kJSQDemoAvatarDisplayNameSokna
                                                   date:[NSDate date]
                                                   text:@"Yes sure! I'm going to have 3 hours code-lab about creating iOS chat app with firebase."],
                   
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSokna
                                      senderDisplayName:kJSQDemoAvatarDisplayNameSokna
                                                   date:[NSDate date]
                                                   text:@"It is going to be awesome"],
                   
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdDuke
                                      senderDisplayName:kJSQDemoAvatarDisplayNameDuke
                                                   date:[NSDate date]
                                                   text:@"Oh really? It sounds interesting."],
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdDuke
                                      senderDisplayName:kJSQDemoAvatarDisplayNameDuke
                                                   date:[NSDate distantPast]
                                                   text:@"I will join your session. When bro?"],
                   
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSokna
                                      senderDisplayName:kJSQDemoAvatarDisplayNameSokna
                                                   date:[NSDate distantPast]
                                                   text:@"Great! It's going to be Saturday from 09:30AM to 12:00PM."],
                   
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdDuke
                                      senderDisplayName:kJSQDemoAvatarDisplayNameDuke
                                                   date:[NSDate distantPast]
                                                   text:@"Ok then! I will invite my friends to join too."],
                   
                   [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSokna
                                      senderDisplayName:kJSQDemoAvatarDisplayNameSokna
                                                   date:[NSDate date]
                                                   text:@"I'm glad to hear that."],
                   nil];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
 
  JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
  
  if ([message.senderId isEqualToString:self.senderId]) {
    return self.outgoingBubbleImageData;
  }
  
  return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}


- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
  

  JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
  
  if (!msg.isMediaMessage) {
    
    if ([msg.senderId isEqualToString:self.senderId]) {
      cell.textView.textColor = [UIColor blackColor];
    }
    else {
      cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
  }
  NSString *imageUrl = self.images[msg.senderId];
  cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame)/2;
  [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:[UIImage profilePlaceholderImage]];
  return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.messages.count;
}

#pragma mark - JSQInputToolbarDelegate

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
  
  //TODO: Send message to firebase
  
}

- (void)didPressAccessoryButton:(UIButton *)sender {
  [FCAlertController showImagePickerInViewController:self
                                            delegate:self];
}


@end
