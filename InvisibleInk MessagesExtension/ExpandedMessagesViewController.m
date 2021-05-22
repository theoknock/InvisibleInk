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

@interface ExpandedMessagesViewController () {
    CGFloat _storedMessageTextViewContentHeight;
}

@end

@implementation ExpandedMessagesViewController

static void (^resizeTextViewFrameToUsedRectForTextContainer)(UITextView * _Nullable, UIButton * _Nullable) = ^ (UITextView * _Nullable textView, UIButton * _Nullable button) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView setFrame:[textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer]];
    });
};

static void (^excludeButtonFrameFromTextView)(UIButton * _Nullable, UITextView * _Nullable) = ^ (UIButton * _Nullable button, UITextView * _Nullable textView) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBezierPath * exclusionPath = [UIBezierPath bezierPathWithRect:button.frame];
        textView.textContainer.exclusionPaths = @[exclusionPath];
    });
};

- (void)viewDidLoad {
    self.messageTextView.textContainer.heightTracksTextView = TRUE;
}

- (IBAction)renderCipherImage:(UIButton *)sender {
    if (self.messageTextView.hasText)
        [self.delegate renderCipherImageWithBlock:^UIImage * _Nonnull (void) {
            CGRect contentsRect = [self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer];
            UIGraphicsBeginImageContextWithOptions(contentsRect.size, YES, [[UIScreen mainScreen] nativeScale]);
            [self.messageTextView drawViewHierarchyInRect:contentsRect afterScreenUpdates:YES];
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
            inputImage = [inputImage imageByApplyingCGOrientation:kCGImagePropertyOrientationUp];
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setDefaults];
            [filter setValue:inputImage forKey:kCIInputImageKey];
            [filter setValue:@(15.0) forKey:kCIInputRadiusKey];
//            [filter setValue:inputImage forKey:kCIInputBackgroundImageKey];
            CIImage *outputImage = [filter outputImage];
            UIImage * cipherImageFile = [UIImage imageWithCIImage:outputImage];
//            UIImage * cipherImageFile = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return cipherImageFile;
        }];
    
    [(typeof (MSMessagesAppViewController *))self.parentViewController requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
}

@end
