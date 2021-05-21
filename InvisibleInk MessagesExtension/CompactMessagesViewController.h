//
//  CompactMessagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/21/21.
//

#import <UIKit/UIKit.h>
@import Messages;

NS_ASSUME_NONNULL_BEGIN

@protocol CompactMessagesViewControllerDelegate <NSObject>

- (void)setMessagesAppViewControllerPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle;

@end

@interface CompactMessagesViewController : UIViewController

@property (weak) id <CompactMessagesViewControllerDelegate> delegate;



@end

NS_ASSUME_NONNULL_END
