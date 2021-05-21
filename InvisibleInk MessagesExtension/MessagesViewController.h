//
//  MessagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import <Messages/Messages.h>
#import "ImagesViewController.h"

@interface MessagesViewController : MSMessagesAppViewController <ImagesViewControllerMessagingDelegate>

@property (weak, nonatomic) IBOutlet UIView *imagesViewControllerContainerView;
@end
