//
//  MessagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "RootMessagesViewController.h"
#import "CompactMessagesViewController.h"
#import "ExpandedMessagesViewController.h"
#import "TranscriptMessagesViewController.h"

#define CompactMessagesViewControllerStoryboardID         @"CompactMessagesViewControllerStoryboardID"
#define CompactMessagesViewControllerPresentationStyle    @"MSMessagesAppPresentationStyleCompact"
#define CompactMessagesViewControllerProtocol             @"CompactMessagesViewControllerDelegate"

#define ExpandedMessagesViewControllerStoryboardID        @"ExpandedMessagesViewControllerStoryboardID"
#define ExpandedMessagesViewControllerPresentationStyle   @"MSMessagesAppPresentationStyleExpanded"
#define ExpandedMessagesViewControllerProtocol            @"ExpandedMessagesViewControllerDelegate"

#define TranscriptMessagesViewControllerStoryboardID      @"TranscriptMessagesViewControllerStoryboardID"
#define TranscriptMessagesViewControllerPresentationStyle @"MSMessagesAppPresentationStyleTranscript"
#define TranscriptMessagesViewControllerProtocol          @"TranscriptMessagesViewControllerDelegate"


@interface RootMessagesViewController () <CompactMessagesViewControllerDelegate, ExpandedMessagesViewControllerDelegate, TranscriptMessagesViewControllerDelegate>

@end

@implementation RootMessagesViewController

static MSSession * sharedSession = NULL;
+ (MSSession *)sharedSession
{
    if ( !sharedSession || sharedSession == NULL )
        {
            sharedSession = [[MSSession alloc] init];
        }

        return sharedSession;
}

static MSMessageTemplateLayout * sharedTemplateLayout = NULL;
+ (MSMessageTemplateLayout *)sharedTemplateLayout
{
    if ( !sharedTemplateLayout || sharedTemplateLayout == NULL )
        {
            sharedTemplateLayout = [[MSMessageTemplateLayout alloc] init];
        }

        return sharedTemplateLayout;
}

static MSMessageLiveLayout * sharedLiveLayout = NULL;
+ (MSMessageLiveLayout *)sharedLiveLayout
{
    if ( !sharedLiveLayout || sharedLiveLayout == NULL )
        {
            sharedLiveLayout = [[MSMessageLiveLayout alloc] initWithAlternateLayout:sharedTemplateLayout];
        }

        return sharedLiveLayout;
}

static MSMessage * sharedMessage = NULL;
+ (MSMessage *)sharedMessage
{
    if ( !sharedMessage || sharedMessage == NULL )
        {
            sharedMessage = [[MSMessage alloc] initWithSession:sharedSession];
        }

        return sharedMessage;
}

//- (typeof(UIViewController *))initChildViewControllerWithIdentifier:(NSString *)identifier {
//    typeof(UIViewController *) childViewController = [self.storyboard instantiateViewControllerWithIdentifier:CompactMessagesViewControllerStoryboardID];
//    [childViewController setDelegate:self];
//
//    return childViewController;
//};

- (void)viewDidLoad
{
    [super viewDidLoad];
    typeof(UIViewController *) presentingChildViewController = nil;
    if (self.presentationStyle != MSMessagesAppPresentationStyleTranscript) {
        presentingChildViewController = (CompactMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:CompactMessagesViewControllerStoryboardID];
        [(CompactMessagesViewController *)presentingChildViewController setDelegate:(id<CompactMessagesViewControllerDelegate>)self];
    } else {
        presentingChildViewController = (TranscriptMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:TranscriptMessagesViewControllerStoryboardID];
        [(TranscriptMessagesViewController *)presentingChildViewController setDelegate:(id<TranscriptMessagesViewControllerDelegate>)self];
    }
    [presentingChildViewController willMoveToParentViewController:self];
    [self addChildViewController:presentingChildViewController];
    [presentingChildViewController didMoveToParentViewController:self];
    
    [presentingChildViewController.view willMoveToSuperview:self.view];
    [self.view addSubview:presentingChildViewController.view];
    [self.view didAddSubview:presentingChildViewController.view];
    
    presentingChildViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    presentingChildViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [presentingChildViewController.view willMoveToSuperview:self.view];
    
}

- (void)willBecomeActiveWithConversation:(MSConversation *)conversation {
    
}


-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.super.willBecomeActive(with: conversation)
    
    // Present the view controller appropriate for the conversation and presentation style.
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dismisses the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
    
    // TO-DO:
    //      1. Get image from message
    //      2. Process using contrast stretch Metal CIFilter
    NSLog(@"%@", sharedMessage.URL.absoluteString);
    
    
    if ([message.senderParticipantIdentifier isEqual:conversation.localParticipantIdentifier])
        NSLog(@"Message sent --- %s", __PRETTY_FUNCTION__);
    else
        NSLog(@"Message recd --- %s", __PRETTY_FUNCTION__);
}

static UIImage * _Nonnull (^imageFromText)(NSString * _Nonnull, UIColor * _Nullable, CGFloat) = ^UIImage * _Nonnull (NSString *text, UIColor *color, CGFloat fontsize) {
    NSMutableParagraphStyle *centerAlignedParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    centerAlignedParagraphStyle.alignment                = NSTextAlignmentCenter;
    NSDictionary *centerAlignedTextAttributes            = @{NSForegroundColorAttributeName : (!color) ? [UIColor redColor] : color,
                                                             NSParagraphStyleAttributeName  : centerAlignedParagraphStyle,
                                                             NSFontAttributeName            : [UIFont systemFontOfSize:fontsize weight:UIFontWeightBlack],
                                                             NSStrokeColorAttributeName     : [UIColor blackColor],
                                                             NSStrokeWidthAttributeName     : [NSNumber numberWithFloat:-2.0]
    };
    
    CGSize textSize = [((!text) ? @"㊏" : text) sizeWithAttributes:centerAlignedTextAttributes];
    UIGraphicsBeginImageContextWithOptions(textSize, NO, 0);
    [text drawAtPoint:CGPointZero withAttributes:centerAlignedTextAttributes];
    
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeZero, fontsize);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
};
    
- (void)sendCipherStickerToView:(MSStickerView *)cipherStickerView
{
//            CGRect contentsRect = self.view.bounds; //[self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer];
//            UIGraphicsBeginImageContextWithOptions(contentsRect.size, YES, [[UIScreen mainScreen] scale]);
//            [self.view drawViewHierarchyInRect:contentsRect afterScreenUpdates:YES];
//            //            [self.messageTextView.textInputView.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage * screenshotFile = UIGraphicsGetImageFromCurrentImageContext();
    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.png"];
    __autoreleasing NSError * fileWriteError = nil;
    if (![UIImagePNGRepresentation(imageFromText(@"Test sticker goes here", [UIColor systemBlueColor], 24.0)) writeToFile:outputPath options:NSDataWritingAtomic error:&fileWriteError]) {
        NSLog(@"Failed to write image to file: %@", fileWriteError.description);
    } else {
        __autoreleasing NSError * stickerInitError = nil;
        NSURL * fileURL = [NSURL fileURLWithPath:outputPath];
        MSSticker * cipherSticker = [[MSSticker alloc] initWithContentsOfFileURL:fileURL localizedDescription:@"The cipher sticker" error:&stickerInitError];
        if (!stickerInitError) {
            [cipherStickerView setSticker:cipherSticker];
        }
    }
//    [cipherImageView setImage:imageFromText(@"Test image from text", [UIColor systemBlueColor], 24.0)];
//            UIGraphicsEndImageContext();
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called before the extension transitions to a new presentation style.
    NSLog(@"Transitioning from %@", self.childViewControllers.firstObject.restorationIdentifier);
    typeof(UIViewController *) presentedChildViewController = self.childViewControllers.firstObject;
    [self.view willRemoveSubview:presentedChildViewController.view];
    [presentedChildViewController.view removeFromSuperview];
    [presentedChildViewController willMoveToParentViewController:nil];
    [presentedChildViewController removeFromParentViewController];
    [presentedChildViewController didMoveToParentViewController:self];
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    NSLog(@"Presentation style: %d", self.presentationStyle);
    //    typeof(UIViewController *) presentingChildViewController = [self initChildViewControllerWithAssociatedProperty:associatedPropertyForPresentationStyle(AssociatedPropertyTypeStoryboardID, presentationStyle)];
    typeof(UIViewController *) presentingChildViewController = nil;
    
    switch (presentationStyle) {
        case MSMessagesAppPresentationStyleCompact: {
            NSLog(@"View Controller: %@", CompactMessagesViewControllerStoryboardID);
            
            presentingChildViewController = (CompactMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:CompactMessagesViewControllerStoryboardID];
            [(CompactMessagesViewController *)presentingChildViewController setDelegate:(id<CompactMessagesViewControllerDelegate>)self];
            
            break;
        }
        case MSMessagesAppPresentationStyleExpanded: {
            NSLog(@"View Controller: %@", ExpandedMessagesViewControllerStoryboardID);
            
            presentingChildViewController = (ExpandedMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:ExpandedMessagesViewControllerStoryboardID];
            [(ExpandedMessagesViewController *)presentingChildViewController setDelegate:(id<ExpandedMessagesViewControllerDelegate>)self];
            
            break;
        }
        case MSMessagesAppPresentationStyleTranscript: {
            NSLog(@"View Controller: %@", TranscriptMessagesViewControllerStoryboardID);
            
            presentingChildViewController = (TranscriptMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:TranscriptMessagesViewControllerStoryboardID];
            [(TranscriptMessagesViewController *)presentingChildViewController setDelegate:(id<TranscriptMessagesViewControllerDelegate>)self];
//            [self.delegate setDelegate:id<RootMessagesViewControllerDelegate>(TranscriptMessagesViewController *)presentingChildViewController];RootMessagesViewControllerDelegate
            break;
        }
        default:
            break;
    }
    
    [presentingChildViewController willMoveToParentViewController:self];
    [self addChildViewController:presentingChildViewController];
    [presentingChildViewController didMoveToParentViewController:self];
    
    [presentingChildViewController.view willMoveToSuperview:self.view];
    [self.view addSubview:presentingChildViewController.view];
    [self.view didAddSubview:presentingChildViewController.view];
    
    NSLog(@"Transitioned to %@", self.childViewControllers.firstObject.restorationIdentifier);
}

- (void)didSelectMessage:(MSMessage *)message conversation:(MSConversation *)conversation
{
    if ([message.senderParticipantIdentifier isEqual:conversation.localParticipantIdentifier])
        NSLog(@"Sender selected message --- %s", __PRETTY_FUNCTION__);
    else
        NSLog(@"Receiver selected message --- %s", __PRETTY_FUNCTION__);
    
}

- (void)renderCipherImageWithBlock:(UIImage * _Nonnull (^)(void))cipherImageFile {
    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.png"];
    __autoreleasing NSError * fileWriteError = nil;
    if (![UIImagePNGRepresentation(cipherImageFile()) writeToFile:outputPath options:NSDataWritingAtomic error:&fileWriteError]) {
        NSLog(@"Failed to write image to file: %@", fileWriteError.description);
    } else {
        __autoreleasing NSError * stickerInitError = nil;
        NSURL * fileURL = [NSURL fileURLWithPath:outputPath];
        MSSticker * cipherSticker = [[MSSticker alloc] initWithContentsOfFileURL:fileURL localizedDescription:@"The cipher sticker" error:&stickerInitError];
        if (!stickerInitError) {
            MSConversation * conversation = self.activeConversation;
            MSSession *ms_session = [RootMessagesViewController sharedSession];
            MSMessageTemplateLayout *ms_templateLayout = [RootMessagesViewController sharedTemplateLayout];
            NSURL * fileURL = [NSURL fileURLWithPath:cipherSticker.imageFileURL.absoluteString];
            [ms_templateLayout setMediaFileURL:fileURL];
            [ms_templateLayout setImage:[UIImage imageWithContentsOfFile:cipherSticker.imageFileURL.absoluteString]];
            [ms_templateLayout setImageTitle:@"Cipher image"];
            
            MSMessageLiveLayout *ms_liveLayout = [RootMessagesViewController sharedLiveLayout];
            NSURL *messageURL = [NSURL URLWithString:@"http://mymessagesapp?arbitraryParam=nothingSpecial"];
            NSURLComponents * components = [NSURLComponents componentsWithURL:messageURL resolvingAgainstBaseURL:false];
            NSURLQueryItem * queryItem = [NSURLQueryItem queryItemWithName:@"arbitraryParam" value:@"nothingSpecial"];
            [components setQueryItems:(NSArray<NSURLQueryItem *> * _Nullable)@[queryItem]];
            MSMessage *ms_message = [RootMessagesViewController sharedMessage];
            [ms_message setURL:components.URL];
            [ms_message setSummaryText:@"Cipher image"];
            [ms_message setLayout:ms_liveLayout];

            [self.activeConversation sendMessage:ms_message completionHandler:^(NSError * _Nullable error) {
                if (error) NSLog(@"Error sending conversation: %@", error.debugDescription);
            }];
            
            [self.activeConversation sendSticker:cipherSticker completionHandler:^(NSError * _Nullable error) {
                if (error) NSLog(@"Error sending sticker: %@", error.debugDescription);
            }];
            
        } else {
            NSLog(@"Failed to create the cipher sticker: %@", stickerInitError.description);
        }
    }
    
    //    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.png"];
    //    __autoreleasing NSError * fileWriteError = nil;
    //    if (![UIImagePNGRepresentation(cipherImageFile()) writeToFile:outputPath options:NSDataWritingAtomic error:&fileWriteError]) {
    //        NSLog(@"Failed to write image to file: %@", fileWriteError.description);
    //    } else {
    //        NSURL * fileURL = [NSURL fileURLWithPath:outputPath];
    //        [self.activeConversation sendAttachment:fileURL withAlternateFilename:outputPath completionHandler:^(NSError * _Nullable error) {
    //            if (error) NSLog(@"Error: %@", error.debugDescription);
    //
    //        }];
    //    }
    
    // To-Do:
    // To get an image that will display in a live layout template, build a sticker
    // (like before) and then use the renderSticker method of MSSticker to the
    // message template layout's image property
    
//    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.png"];
//    __autoreleasing NSError * fileWriteError = nil;
//    UIImage *cipherImage = cipherImageFile();
//    if (![UIImagePNGRepresentation(cipherImage) writeToFile:outputPath options:NSDataWritingAtomic error:&fileWriteError]) {
//        NSLog(@"Failed to write image to file: %@", fileWriteError.description);
//    } else {
//        MSSession *ms_session = [RootMessagesViewController sharedSession];
//        MSMessageTemplateLayout *ms_templateLayout = [RootMessagesViewController sharedTemplateLayout];
//        NSURL * fileURL = [NSURL fileURLWithPath:outputPath];
//        [ms_templateLayout setMediaFileURL:fileURL];
//        [ms_templateLayout setImage:[UIImage imageWithContentsOfFile:fileURL.absoluteString]];
//        [ms_templateLayout setImageTitle:@"Cipher image"];
//
//        MSMessageLiveLayout *ms_liveLayout = [RootMessagesViewController sharedLiveLayout];
//        NSURL *messageURL = [NSURL URLWithString:@"http://mymessagesapp?arbitraryParam=nothingSpecial"];
//        NSURLComponents * components = [NSURLComponents componentsWithURL:messageURL resolvingAgainstBaseURL:false];
//        NSURLQueryItem * queryItem = [NSURLQueryItem queryItemWithName:@"arbitraryParam" value:@"nothingSpecial"];
//        [components setQueryItems:(NSArray<NSURLQueryItem *> * _Nullable)@[queryItem]];
//        MSMessage *ms_message = [RootMessagesViewController sharedMessage];
//        [ms_message setURL:components.URL];
//        [ms_message setSummaryText:@"Cipher image"];
//        [ms_message setLayout:ms_liveLayout];
//
//        [self.activeConversation sendMessage:ms_message completionHandler:^(NSError * _Nullable error) {
//            if (error) NSLog(@"Error: %@", error.debugDescription);
//        }];
//
//        NSLog(@"session %@", ms_session);
//        //        [self.activeConversation insertAttachment:fileURL  withAlternateFilename:@"output.png" completionHandler:^(NSError * _Nullable error) {
//        //            if (error) NSLog(@"Error: %@", error.debugDescription);
//        //        }];
//    }
    
    
}

@end
