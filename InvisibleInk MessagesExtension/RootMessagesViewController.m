//
//  MessagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "RootMessagesViewController.h"

@interface RootMessagesViewController () <CompactMessagesViewControllerDelegate,
ExpandedMessagesViewControllerDelegate, MSMessagesAppTranscriptPresentation>

@property (nonatomic, copy) void (^presentationStyleForRootMessagesViewController)(MSMessagesAppPresentationStyle);


@end

@implementation RootMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Conversation Handling

static void (^removeChildViewControllers)(NSArray<__kindof UIViewController *> *) = ^(NSArray<__kindof UIViewController *> *childViewControllers) {
    for (__kindof UIViewController * childViewController in childViewControllers) {
        [childViewController willMoveToParentViewController:nil];
        [[childViewController view] removeFromSuperview];
        [childViewController removeFromParentViewController];
    }
};
//
//static void (^addChildViewControllerToParent)(__weak __typeof__(UIViewController * _Nonnull), __weak __typeof__(UIViewController * _Nonnull)) = ^(__weak __typeof__(UIViewController * _Nonnull)w_childViewController, __weak __typeof__(UIViewController * _Nonnull)w_parentViewController) {
//    __strong __typeof__ (UIViewController *) s_parentViewController = w_parentViewController;
//    __strong __typeof__ (UIViewController *) s_childViewController = w_childViewController;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        removeChildViewControllers([s_parentViewController childViewControllers]);
//        
//        [s_parentViewController addChildViewController:s_childViewController];
//        [s_childViewController didMoveToParentViewController:s_parentViewController];
//        
//        // match the child size to its parent
//        CGRect frame = s_childViewController.view.frame;
//        frame.size.height = CGRectGetHeight(((RootMessagesViewController *)s_parentViewController).view.frame);
//        frame.size.width = CGRectGetWidth(((RootMessagesViewController *)s_parentViewController).view.frame);
//        s_childViewController.view.frame = frame;
//        
//        [((RootMessagesViewController *)s_parentViewController).view addSubview:s_childViewController.view];
//        
//        if ([s_childViewController isKindOfClass:[ExpandedMessagesViewController class]])
//            [(ExpandedMessagesViewController *)s_childViewController setDelegate:(id <ExpandedMessagesViewControllerDelegate>)s_parentViewController];
//    });
//};

static void (^presentationStyleForRootMessagesViewController)(MSMessagesAppPresentationStyle, UIStoryboard *) = ^(MSMessagesAppPresentationStyle presentationStyle, UIStoryboard * storyboard) {
//    __strong __typeof__ (RootMessagesViewController *)s_self = w_presentingViewController;
    __typeof__(UIViewController *)childViewController = nil;
    switch (presentationStyle) {
        case MSMessagesAppPresentationStyleExpanded:
        {
            childViewController = (ExpandedMessagesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ExpandedMessagesViewController"];
            [(ExpandedMessagesViewController *)childViewController setDelegate:((RootMessagesViewController *)((ExpandedMessagesViewController *)childViewController).delegate)];
            break;
        }
            
        case MSMessagesAppPresentationStyleCompact:
        {
            childViewController = (CompactMessagesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CompactMessagesViewController"];
            [(CompactMessagesViewController *)childViewController setDelegate:((RootMessagesViewController *)((CompactMessagesViewController *)childViewController).delegate)];
            break;
        }
            
        default:
            break;
    }
    
    // TO-DO: Must re-add next!!!
//    [childViewController willMoveToParentViewController:nil];
//    [[childViewController view] removeFromSuperview];
//    [childViewController removeFromParentViewController];
//    removeChildViewControllers([s_self childViewControllers]);
    
//    if (presentationStyle == MSMessagesAppPresentationStyleExpanded) {
//        [s_self requestPresentationStyle:presentationStyle];
        
        [s_self addChildViewController:vc];
        [s_self.view addSubview:vc.view];
        
        CGRect vcViewRect = s_self.view.bounds;
        vc.view.frame = vcViewRect;
        
        [vc didMoveToParentViewController:s_self];
       
//        [expandedMessagesViewController setDelegate:(id<ExpandedMessagesViewControllerDelegate>)s_self];
//    } else
////        if (presentationStyle == MSMessagesAppPresentationStyleCompact)
//        {
//            [s_self requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
//
//            [s_self addChildViewController:compactMessagesViewController];
//            [s_self.view addSubview:compactMessagesViewController.view];
//
//            // Set the calendar root view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
//            CGRect compactMessagesViewRect = s_self.view.bounds;
//            compactMessagesViewController.view.frame = compactMessagesViewRect;
//
//            [compactMessagesViewController didMoveToParentViewController:s_self];
//            [compactMessagesViewController setDelegate:(id<CompactMessagesViewControllerDelegate>)s_self];
//
//        }
    
    //    addChildViewControllerToParent(presentedViewController, s_self);
    //    presentedViewController.view.frame = s_self.view.bounds;
    //
    //    presentedViewController.view.translatesAutoresizingMaskIntoConstraints = FALSE;
    //    [s_self.view addSubview:presentedViewController.view];
    //
    //    [presentedViewController didMoveToParentViewController:s_self];
};

- (void)willBecomeActiveWithConversation:(MSConversation *)conversation {
    [super willBecomeActiveWithConversation:conversation];
    __weak __typeof__ (self) w_self = self;
    //    presentViewController(MSMessagesAppPresentationStyleCompact, w_self);
}


-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.super.willBecomeActive(with: conversation)
    
    // Present the view controller appropriate for the conversation and presentation style.
    //    [super didBecomeActiveWithConversation:conversation];
    //    __weak __typeof__ (self) w_self = self;
    //    presentViewController(MSMessagesAppPresentationStyleCompact, w_self);
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
    
    // Use this method to prepare for the change in presentation style.
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
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
            [conversation insertSticker:cipherSticker completionHandler:^(NSError * _Nullable insertStickerError) {
                if (insertStickerError) NSLog(@"Failed to insert cipher sticker into the current conversation");
            }];
        } else {
            NSLog(@"Failed to create the cipher sticker: %@", stickerInitError.description);
        }
    }
}

- (CGSize)contentSizeThatFits:(CGSize)size {
    return self.childViewControllers.firstObject.view.frame.size;
}

//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    //
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    //
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    //
//}

//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    return self.imagesViewControllerContainerView.frame.size;
//}

//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    //
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    /
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    //
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    //
//}
//
//- (void)setNeedsFocusUpdate {
//    //
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    //
//}
//
//- (void)updateFocusIfNeeded {
//    //
//}


//// MARK: Properties
//
//
//// MARK: MSMessagesAppViewController overrides
//
//override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
//    super.willTransition(to: presentationStyle)
//
//    // Hide child view controllers during the transition.
//    removeAllChildViewControllers()
//}
//
//override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
//    super.didTransition(to: presentationStyle)
//
//    // Present the view controller appropriate for the conversation and presentation style.
//    guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
//    presentViewController(for: conversation, with: presentationStyle)
//}
//
//// MARK: Child view controller presentation
//
//
//
///// - Tag: PresentViewController
//private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
//    // Remove any child view controllers that have been presented.
//    removeAllChildViewControllers()
//
//    let controller: UIViewController
//    if presentationStyle == .compact {
//        // Show a list of previously created ice creams.
//        controller = instantiateIceCreamsController()
//    } else {
//        // Parse an `IceCream` from the conversation's `selectedMessage` or create a new `IceCream`.
//        let iceCream = IceCream(message: conversation.selectedMessage) ?? IceCream()
//
//        // Show either the in process construction process or the completed ice cream.
//        if iceCream.isComplete {
//            controller = instantiateCompletedIceCreamController(with: iceCream)
//        } else {
//            controller = instantiateBuildIceCreamController(with: iceCream)
//        }
//    }
//
//        addChild(controller)
//        controller.view.frame = view.bounds
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(controller.view)
//
//        NSLayoutConstraint.activate([
//                                     controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
//                                     controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
//                                     controller.view.topAnchor.constraint(equalTo: view.topAnchor),
//                                     controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//                                     ])
//
//        controller.didMove(toParent: self)
//        }
//
//private func instantiateIceCreamsController() -> UIViewController {
//    guard let controller = storyboard?.instantiateViewController(withIdentifier: IceCreamsViewController.storyboardIdentifier)
//    as? IceCreamsViewController
//    else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
//
//    controller.delegate = self
//
//    return controller
//}
//
//private func instantiateBuildIceCreamController(with iceCream: IceCream) -> UIViewController {
//    guard let controller = storyboard?.instantiateViewController(withIdentifier: BuildIceCreamViewController.storyboardIdentifier)
//    as? BuildIceCreamViewController
//    else { fatalError("Unable to instantiate a BuildIceCreamViewController from the storyboard") }
//
//    controller.iceCream = iceCream
//    controller.delegate = self
//
//    return controller
//}
//
//private func instantiateCompletedIceCreamController(with iceCream: IceCream) -> UIViewController {
//    // Instantiate a `BuildIceCreamViewController`.
//    guard let controller = storyboard?.instantiateViewController(withIdentifier: CompletedIceCreamViewController.storyboardIdentifier)
//    as? CompletedIceCreamViewController
//    else { fatalError("Unable to instantiate a CompletedIceCreamViewController from the storyboard") }
//
//    controller.iceCream = iceCream
//
//    return controller
//}
//
//// MARK: Convenience
//
//private func removeAllChildViewControllers() {
//    for child in children {
//        child.willMove(toParent: nil)
//        child.view.removeFromSuperview()
//        child.removeFromParent()
//    }
//}



@end
