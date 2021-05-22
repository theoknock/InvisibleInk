//
//  CompactMessagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/21/21.
//

#import "CompactMessagesViewController.h"

@interface CompactMessagesViewController ()

@end

@implementation CompactMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setDelegate:(id<CompactMessagesViewControllerDelegate> _Nullable)((RootMessagesViewController *)self.parentViewController)];
}

- (IBAction)presentExpandedMessagesViewController:(UIButton *)sender {
//    _RootMessagesViewController * w_rootMessagesViewController = (RootMessagesViewController *)self.compactMessagesViewControllerDelegate;
    [(typeof (MSMessagesAppViewController *))self.parentViewController requestPresentationStyle:MSMessagesAppPresentationStyleExpanded];
//    [self.delegate swapChildViewControllers];
}


@end
