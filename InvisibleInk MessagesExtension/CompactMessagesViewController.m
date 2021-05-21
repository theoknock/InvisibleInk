//
//  CompactMessagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/21/21.
//

#import "CompactMessagesViewController.h"
#import "MessagesViewController.h"

@interface CompactMessagesViewController ()

@end

@implementation CompactMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDelegate:(id<CompactMessagesViewControllerDelegate> _Nullable)((MessagesViewController *)self.parentViewController)];
}

- (IBAction)presentExpandedMessagesViewController:(UIButton *)sender {
    [(MessagesViewController *)self.parentViewController requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
}


@end
