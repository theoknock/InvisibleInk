//
//  TranscriptMessagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/22/21.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>


NS_ASSUME_NONNULL_BEGIN

@protocol TranscriptMessagesViewControllerDelegate;

@interface TranscriptMessagesViewController : UIViewController

@property (weak, nonatomic) id <TranscriptMessagesViewControllerDelegate>delegate;

@end

@protocol TranscriptMessagesViewControllerDelegate <NSObject>

@end

NS_ASSUME_NONNULL_END
