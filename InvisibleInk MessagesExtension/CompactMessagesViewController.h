//
//  CompactMessagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/21/21.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>

#import "UIViewController+MessageViewControllerDelegate.h"

@protocol CompactMessagesViewControllerDelegate;

@interface CompactMessagesViewController : UIViewController

@property (weak, nonatomic) id <CompactMessagesViewControllerDelegate>delegate;

@end

@protocol CompactMessagesViewControllerDelegate <NSObject>

@end
