//
//  CompactMessagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/21/21.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>

@protocol CompactMessagesViewControllerDelegate;

@interface CompactMessagesViewController : UIViewController

@property (weak, nonatomic) id <CompactMessagesViewControllerDelegate>delegate;

@end

@protocol CompactMessagesViewControllerDelegate <NSObject>

- (void)swapChildViewControllers;
- (void)presentChildViewControllerWithAssociatedProperty:(NSString *)associatedProperty;
//@property (nonatomic, copy) void (^presentationStyleForRootMessagesViewController)(MSMessagesAppPresentationStyle);
//@property ( nonatomic, copy) void (^onTransactionCompleted)();- (void)setMessagesAppViewControllerPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle;
//- (void)setMessagesAppViewControllerPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle;

@end
