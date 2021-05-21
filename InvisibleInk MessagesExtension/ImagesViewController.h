//
//  ImagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void (^ _Nonnull renderCipherImageFile)(UIImage * _Nonnull);
//- (void)cipherImageFileWithRenderer:(void(^)(renderCipherImageFile))renderCipherImageFileHandler;


@protocol ImagesViewControllerMessagingDelegate <NSObject>

- (void)renderCipherImageWithBlock:(UIImage * _Nonnull (^)(void))cipherImageFile;

@end

@interface ImagesViewController : UIViewController <UITextViewDelegate>

@property (weak) id <ImagesViewControllerMessagingDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UIButton *renderCIpherImageButton;

@end

NS_ASSUME_NONNULL_END
