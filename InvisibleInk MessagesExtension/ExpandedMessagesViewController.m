//
//  ImagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "ExpandedMessagesViewController.h"
#import "RootMessagesViewController.h"

// TO-DO:   Add a callback shimmer to the layer of the UITextView that
//          creates a shimmering mirage effect on the text to be encrypted
//          (the code for this can be found in ViewController.m -- search for
//          'reference to view controller in block' with Spotlight to find it)
//

@interface ExpandedMessagesViewController ()

@end

@implementation ExpandedMessagesViewController

static void (^resizeTextViewFrameToUsedRectForTextContainer)(UITextView * _Nullable, UIButton * _Nullable) = ^ (UITextView * _Nullable textView, UIButton * _Nullable button) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView setFrame:[textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer]];
    });
};

- (void)viewDidLoad {
    self.messageTextView.textContainer.heightTracksTextView = TRUE;
    [self.messageTextView selectAll:nil];
}

- (IBAction)renderCipherImage:(UIButton *)sender {
    [self.messageTextView endEditing:TRUE];
    if (self.messageTextView.hasText)
    {
        CGRect contentsRect = self.messageTextView.bounds; //[self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer];
        UIGraphicsBeginImageContextWithOptions(contentsRect.size, YES, [[UIScreen mainScreen] scale]);
        [self.messageTextView drawViewHierarchyInRect:contentsRect afterScreenUpdates:YES];
        //            [self.messageTextView.textInputView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cipherImageFile = UIGraphicsGetImageFromCurrentImageContext();
        [self.delegate renderCipherImageWithBlock:^UIImage * _Nonnull (void) {
            return cipherImageFile;
        }];
        UIGraphicsEndImageContext();
        
        [(typeof (MSMessagesAppViewController *))self.parentViewController requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
    }
}

@end
