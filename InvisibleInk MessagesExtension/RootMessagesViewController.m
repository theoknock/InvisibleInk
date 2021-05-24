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

static MSSession *session = nil;
+ (MSSession *)session {
    if (!session)
        session = [[MSSession alloc] init];
    
    return session;
}

static MSMessageTemplateLayout *templateLayout = nil;
+ (MSMessageLayout *)templateLayout {
    if (!templateLayout)
        templateLayout = [[MSMessageTemplateLayout alloc] init];
    
    return templateLayout;
}

static MSMessageLiveLayout *liveLayout = nil;
+ (MSMessageLiveLayout *)liveLayout {
    if (!liveLayout)
        liveLayout = [[MSMessageLiveLayout alloc] initWithAlternateLayout:templateLayout];
    
    return liveLayout;
}

static MSMessage *cipherMessage = nil;
+ (MSMessage *)cipherMessage {
    if (!cipherMessage) {
        cipherMessage = [[MSMessage alloc] initWithSession:session];
        [cipherMessage setLayout:liveLayout];
    }
    
    return cipherMessage;
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
    NSLog(@"%@", cipherMessage.URL.absoluteString);
    
    
    if ([message.senderParticipantIdentifier isEqual:conversation.localParticipantIdentifier])
        NSLog(@"Message sent --- %s", __PRETTY_FUNCTION__);
    else
        NSLog(@"Message recd --- %s", __PRETTY_FUNCTION__);
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
    
    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.png"];
    __autoreleasing NSError * fileWriteError = nil;
    if (![UIImagePNGRepresentation(cipherImageFile()) writeToFile:outputPath options:NSDataWritingAtomic error:&fileWriteError]) {
        NSLog(@"Failed to write image to file: %@", fileWriteError.description);
    } else {
        MSSession *ms_session = [[MSSession alloc] init];
        MSMessageTemplateLayout *ms_templateLayout = [[MSMessageTemplateLayout alloc] init];
        NSURL * fileURL = [NSURL fileURLWithPath:outputPath];
        [templateLayout setMediaFileURL:fileURL];
        [templateLayout setImage:[UIImage imageWithContentsOfFile:outputPath]];
        [templateLayout setImageTitle:@"Cipher image"];
        
        MSMessageLiveLayout *ms_liveLayout = [[MSMessageLiveLayout alloc] initWithAlternateLayout:ms_templateLayout];
        NSURL *messageURL = [NSURL URLWithString:@"http://mymessagesapp?arbitraryParam=nothingSpecial"];
        NSURLComponents * components = [NSURLComponents componentsWithURL:messageURL resolvingAgainstBaseURL:false];
        NSURLQueryItem * queryItem = [NSURLQueryItem queryItemWithName:@"arbitraryParam" value:@"nothingSpecial"];
        [components setQueryItems:(NSArray<NSURLQueryItem *> * _Nullable)@[queryItem]];
        MSMessage *ms_message = [[MSMessage alloc] initWithSession:ms_session];
        [ms_message setURL:components.URL];
        [ms_message setSummaryText:@"Cipher image"];
        [ms_message setLayout:ms_liveLayout];
        [self.activeConversation sendMessage:ms_message completionHandler:^(NSError * _Nullable error) {
            if (error) NSLog(@"Error: %@", error.debugDescription);
        }];
        
        NSLog(@"session %@", ms_session);
        //        [self.activeConversation insertAttachment:fileURL  withAlternateFilename:@"output.png" completionHandler:^(NSError * _Nullable error) {
        //            if (error) NSLog(@"Error: %@", error.debugDescription);
        //        }];
    }
    
    
}

- (CGSize)contentSizeThatFits:(CGSize)size
{
    CGSize liveLayoutTemplateSize = CGSizeMake(300.0, 300.0);
    return liveLayoutTemplateSize;
}

@end
