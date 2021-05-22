//
//  MessagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "RootMessagesViewController.h"
#import "CompactMessagesViewController.h"
#import "ExpandedMessagesViewController.h"

#define CompactMessagesViewControllerStoryboardID @"CompactMessagesViewControllerStoryboardID"
#define CompactMessagesViewControllerPresentationStyle @"MSMessagesAppPresentationStyleCompact"

#define ExpandedMessagesViewControllerStoryboardID @"ExpandedMessagesViewControllerStoryboardID"
#define ExpandedMessagesViewControllerPresentationStyle @"MSMessagesAppPresentationStyleExpanded"


@interface RootMessagesViewController () <CompactMessagesViewControllerDelegate, ExpandedMessagesViewControllerDelegate>

@property (strong, nonatomic) CompactMessagesViewController * compactMessagesViewController;
@property (strong, nonatomic) ExpandedMessagesViewController * expandedMessagesViewController;

@end

@implementation RootMessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    typeof(UIViewController *) presentingChildViewController = [self initChildViewControllerWithAssociatedProperty:CompactMessagesViewControllerStoryboardID];
    
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

static MSMessagesAppPresentationStyle (^presentationStyleFromAssociatedProperty)(NSString *) = ^MSMessagesAppPresentationStyle (NSString *associatedProperty) {
    MSMessagesAppPresentationStyle presentationStyle = ([associatedProperty isEqualToString:CompactMessagesViewControllerStoryboardID] ||
                                                        [associatedProperty isEqualToString:CompactMessagesViewControllerPresentationStyle])
                                                        ?
                                                            MSMessagesAppPresentationStyleCompact
                                                        :
                                                       ([associatedProperty isEqualToString:CompactMessagesViewControllerStoryboardID] ||
                                                        [associatedProperty isEqualToString:CompactMessagesViewControllerPresentationStyle])
                                                        ?
                                                            MSMessagesAppPresentationStyleExpanded
                                                        :
                                                            MSMessagesAppPresentationStyleCompact;
    
    return presentationStyle;
};

typedef NS_ENUM(NSUInteger, AssociatedPropertyType) {
    AssociatedPropertyTypeStoryboardID,
    AssociatedPropertyTypePresentationStyle
};

static NSString * (^associatedPropertyForPresentationStyle)(AssociatedPropertyType, MSMessagesAppPresentationStyle) = ^ NSString * (AssociatedPropertyType type, MSMessagesAppPresentationStyle presentationStyle) {
    return
    
    (presentationStyle == MSMessagesAppPresentationStyleCompact)
    ?
    (type == AssociatedPropertyTypeStoryboardID) ? CompactMessagesViewControllerStoryboardID : CompactMessagesViewControllerPresentationStyle
    :
    (type == AssociatedPropertyTypeStoryboardID) ? ExpandedMessagesViewControllerStoryboardID : ExpandedMessagesViewControllerPresentationStyle;
    
};

- (UIViewController *)initChildViewControllerWithAssociatedProperty:(NSString *)associatedProperty
{
    UIViewController * childViewController = nil;
    MSMessagesAppPresentationStyle presentationStyle = presentationStyleFromAssociatedProperty(associatedProperty);
    switch (presentationStyle) {
        case MSMessagesAppPresentationStyleCompact: {
            self.compactMessagesViewController = (CompactMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:CompactMessagesViewControllerStoryboardID];
            [self.compactMessagesViewController setDelegate:(id<CompactMessagesViewControllerDelegate>)self];
            childViewController = self.compactMessagesViewController;
            break;
        }
        case MSMessagesAppPresentationStyleExpanded: {
            self.expandedMessagesViewController = (ExpandedMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:ExpandedMessagesViewControllerStoryboardID];
            [self.expandedMessagesViewController setDelegate:(id<ExpandedMessagesViewControllerDelegate>)self];
            childViewController = self.expandedMessagesViewController;
            break;
        }
        default:
            break;
    }
    
    return childViewController;
}

- (typeof (UIViewController *))childViewControllerForAssociatedProperty:(NSString *)associatedProperty
{
    return
    
    ([associatedProperty isEqualToString:CompactMessagesViewControllerStoryboardID] ||
     [associatedProperty isEqualToString:CompactMessagesViewControllerPresentationStyle])
    ?
        (!self.compactMessagesViewController)
        ?
            (CompactMessagesViewController *)[self initChildViewControllerWithAssociatedProperty:CompactMessagesViewControllerStoryboardID]
        :
            (CompactMessagesViewController *)self.compactMessagesViewController
    :
    ([associatedProperty isEqualToString:ExpandedMessagesViewControllerStoryboardID] ||
     [associatedProperty isEqualToString:ExpandedMessagesViewControllerPresentationStyle])
    ?
        (!self.expandedMessagesViewController)
        ?
            (ExpandedMessagesViewController *)[self initChildViewControllerWithAssociatedProperty:ExpandedMessagesViewControllerStoryboardID]
        :
            (ExpandedMessagesViewController *)self.expandedMessagesViewController
    : nil;
}

// Called by the root view controller at initialization and
// by all view controllers to transition between presentation styles
//- (void)presentChildViewControllerWithAssociatedProperty:(NSString *)associatedProperty {
//    NSLog(@"Switching to %@\n", associatedProperty);
//    typeof(UIViewController *) presentingChildViewController = [self childViewControllerForAssociatedProperty:associatedProperty];
//    
//    // add NSNumber to UIViewController for presentation style
//    // use accessor methods to get and set (like count for NSArray)
//    
//    if (self.childViewControllers.count > 0) {
//        NSLog(@"Removing %@", self.childViewControllers.firstObject);
//        typeof(UIViewController *) presentedChildViewController = self.childViewControllers.firstObject;
//        [self.view willRemoveSubview:presentedChildViewController.view];
//        [presentedChildViewController.view removeFromSuperview];
//        [presentedChildViewController willMoveToParentViewController:nil];
//        [presentedChildViewController removeFromParentViewController];
//        [presentedChildViewController didMoveToParentViewController:self];
//    }
//    
//    [presentingChildViewController willMoveToParentViewController:self];
//    [self addChildViewController:presentingChildViewController];
//    [presentingChildViewController didMoveToParentViewController:self];
//    
//    [presentingChildViewController.view willMoveToSuperview:self.view];
//    [self.view addSubview:presentingChildViewController.view];
//    [self.view didAddSubview:presentingChildViewController.view];
//    
//    presentingChildViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    presentingChildViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [presentingChildViewController.view willMoveToSuperview:self.view];
//    
//    
//    NSLog(@"Switched to %@\n", associatedProperty);
//    NSLog(@"Number of child view controllers: %lu", self.childViewControllers.count);
//}
//
//- (void)swapChildViewControllers {
//    NSLog(@"---------------");
//    NSLog(@"Swapping out %@", self.childViewControllers.firstObject.restorationIdentifier);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self presentChildViewControllerWithAssociatedProperty:([self.childViewControllers.firstObject.restorationIdentifier isEqualToString:CompactMessagesViewControllerStoryboardID])
//                                                                ?
//                                                                    ExpandedMessagesViewControllerStoryboardID
//                                                                :
//                                                                    ([self.childViewControllers.firstObject.restorationIdentifier isEqualToString:ExpandedMessagesViewControllerStoryboardID])
//                                                                    ?
//                                                                        CompactMessagesViewControllerStoryboardID
//                                                                    :   ExpandedMessagesViewControllerStoryboardID];
//    });
//}
//

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
    
//    if (presentationStyle == MSMessagesAppPresentationStyleExpanded) {
//        // remove Compact...
//    } else {
//        // remove Expanded...
//    }
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
//    typeof(UIViewController *) presentingChildViewController = [self initChildViewControllerWithAssociatedProperty:associatedPropertyForPresentationStyle(AssociatedPropertyTypeStoryboardID, presentationStyle)];
    typeof(UIViewController *) presentingChildViewController = nil;
    
    switch (presentationStyle) {
        case MSMessagesAppPresentationStyleCompact: {
            presentingChildViewController = (CompactMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:CompactMessagesViewControllerStoryboardID];
            [(CompactMessagesViewController *)presentingChildViewController setDelegate:(id<CompactMessagesViewControllerDelegate>)self];
            
            break;
        }
        case MSMessagesAppPresentationStyleExpanded: {
            presentingChildViewController = (ExpandedMessagesViewController *)[self.storyboard instantiateViewControllerWithIdentifier:ExpandedMessagesViewControllerStoryboardID];
            [(ExpandedMessagesViewController *)self.expandedMessagesViewController setDelegate:(id<ExpandedMessagesViewControllerDelegate>)self];
            
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
    
    presentingChildViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    presentingChildViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [presentingChildViewController.view willMoveToSuperview:self.view];
    
    NSLog(@"Transitioned to %@", self.childViewControllers.firstObject.restorationIdentifier);
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

@end
