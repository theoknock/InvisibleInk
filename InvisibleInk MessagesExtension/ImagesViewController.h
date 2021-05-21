//
//  ImagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImagesViewControllerMessagingDelegate <NSObject>

- (void)composeTestMessage:(NSString *)messageText;
- (void)insertCipherImageAtPath:(NSString *)cipherImagePath;

@end

@interface ImagesViewController : UIViewController <UITextViewDelegate>

- (IBAction)sendTestMessage:(UIButton *)sender;

@property (weak) id <ImagesViewControllerMessagingDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end

NS_ASSUME_NONNULL_END
