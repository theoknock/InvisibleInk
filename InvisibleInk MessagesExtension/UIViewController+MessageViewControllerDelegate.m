//
//  UIViewController+MessageViewControllerDelegate.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/23/21.
//

#import "UIViewController+MessageViewControllerDelegate.h"

@implementation UIViewController (MessageViewControllerDelegate)

@dynamic delegate;

- (void)setDelegate:(id)delegate {
    delegate = self.delegate;
}

- (id)delegate {
    return self.delegate;
}

@end
