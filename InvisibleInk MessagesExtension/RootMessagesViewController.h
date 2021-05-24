//
//  MessagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>

@protocol RootMessagesViewControllerDelegate;

@interface RootMessagesViewController : MSMessagesAppViewController

+ (nonnull MSSession *)sharedSession;
+ (nonnull MSMessageTemplateLayout *)sharedTemplateLayout;
+ (nonnull MSMessageLiveLayout *)sharedLiveLayout;
+ (nonnull MSMessage *)sharedMessage;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) id <RootMessagesViewControllerDelegate>delegate;

@end

@protocol RootMessagesViewControllerDelegate <NSObject>

@optional
@property (weak, nonatomic) IBOutlet UIImageView *cipherImageView;

@end


