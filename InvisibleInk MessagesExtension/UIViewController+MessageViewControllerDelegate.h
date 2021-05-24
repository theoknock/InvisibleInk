//
//  UIViewController+MessageViewControllerDelegate.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MessagesViewControllerDelegate;

@interface UIViewController (MessageViewControllerDelegate)

@property (weak) id<MessagesViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
