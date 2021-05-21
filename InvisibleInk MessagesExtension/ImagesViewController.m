//
//  ImagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "ImagesViewController.h"

@interface ImagesViewController ()

@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)setDelegate:(id<ImagesViewControllerMessagingDelegate>)delegate
//{
//    self.delegate = delegate;
//}
//
//- (id<ImagesViewControllerMessagingDelegate>)delegate {
//    return self.delegate;
//}

- (void)textViewDidChange:(UITextView *)textView {
    [self.delegate composeTestMessage:textView.text];
}

- (IBAction)sendTestMessage:(UIButton *)sender {
    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"cipherImage.png"];
    CALayer *textViewLayer = (CALayer *)[self.messageTextView layer];
    UIGraphicsBeginImageContextWithOptions(self.messageTextView.textInputView.bounds.size, TRUE, 0);
    CGRect contextRect = CGRectMake(0.0, 0.0,
                                    self.messageTextView.textInputView.bounds.size.width,
                                    self.messageTextView.textInputView.bounds.size.height);
    [textViewLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cipherImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
       if (![UIImagePNGRepresentation(cipherImage) writeToFile:outputPath atomically:YES]) {
           NSLog(@"Failed to write image to file");
       } else {
           [self.delegate insertCipherImageAtPath:outputPath];
       }
    
}


@end
