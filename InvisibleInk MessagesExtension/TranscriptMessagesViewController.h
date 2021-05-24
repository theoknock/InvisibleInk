//
//  TranscriptMessagesViewController.h
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/22/21.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>

#import "RootMessagesViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TranscriptMessagesViewControllerDelegate;

@interface TranscriptMessagesViewController : MSMessagesAppViewController <MSMessagesAppTranscriptPresentation, RootMessagesViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cipherImageView;

@property (weak, nonatomic) IBOutlet MSStickerView *cipherStickerView;

@property (weak, nonatomic) id <TranscriptMessagesViewControllerDelegate>delegate;

@end

@protocol TranscriptMessagesViewControllerDelegate <NSObject>

- (void)sendCipherStickerToView:(MSStickerView *)cipherStickerView;

@end

NS_ASSUME_NONNULL_END
