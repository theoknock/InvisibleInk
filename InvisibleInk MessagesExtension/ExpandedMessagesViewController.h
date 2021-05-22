//
//  ImagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>

#import "RootMessagesViewController.h"

@class RootMessagesViewController;

@protocol ExpandedMessagesViewControllerDelegate;

//typedef NSString * _Nonnull (^ _Nonnull MessageFromTextViewHandler)(UITextView * _Nonnull textView);
//typedef UIImage * _Nonnull (^ _Nonnull CipherImageFromMessageHandler)(MessageFromTextViewHandler messageFromTextView);
//typedef void (^ _Nonnull FileFromCipherImageHandler)(CipherImageFromMessageHandler cipherImageFromMessage);
//- (void)cipherImageFileWithRenderer:(void(^)(renderCipherImageFile))renderCipherImageFileHandler;

@interface ExpandedMessagesViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) id <ExpandedMessagesViewControllerDelegate> _Nullable delegates;

@property (weak, nonatomic) IBOutlet UITextView * messageTextView;
@property (weak, nonatomic) IBOutlet UIButton * renderCipherImageButton;

@end

@protocol ExpandedMessagesViewControllerDelegate <NSObject>

- (void)renderCipherImageWithBlock:(UIImage * _Nonnull (^ _Nonnull)(void))cipherImageFile;
@property (nonatomic, copy) void (^ _Nonnull  presentationStyleForRootMessagesViewController)(MSMessagesAppPresentationStyle, __weak RootMessagesViewController * _Nonnull);
//@property ( nonatomic, copy) void (^onTransactionCompleted)();- (void)setMessagesAppViewControllerPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle;

@end
