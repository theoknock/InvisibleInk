//
//  MessagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>

@interface RootMessagesViewController : MSMessagesAppViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
