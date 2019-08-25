//
//  FeedbackViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "FeedbackViewController.h"
#import <APMultiMenu.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <MessageUI/MessageUI.h>
@interface FeedbackViewController () <UITextViewDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *textViewbg;

@end

@implementation FeedbackViewController
- (IBAction)feedbackButtonTouched:(id)sender
{
    if (_textView.text.length == 0 || [_textView.text isEqualToString:@"Write Here!"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Feedback Text" subTitle:@"Please Add Feedback." closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] isEqualToString:@"Guest"]) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"Signup or Login" subTitle:@"Please signup or Login for this Action" closeButtonTitle:@"OK" duration:0.0f];
        }
        else
        {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:@"World is Amazing"];
            [mail setMessageBody:@"" isHTML:NO];
            [mail setToRecipients:@[@"decentdude19@gmail.com"]];
            
            [self presentViewController:mail animated:YES completion:NULL];
        }
        else
        {
            NSLog(@"This device cannot send email");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Configure Your Email" message:@"Please configure your email account before sending Feedback" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //button click event
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        }
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftMenu:)];
    self.title = @"Send Feedback Here!";
    
    self.feedbackButton.layer.cornerRadius=5.0;
    self.textView.layer.cornerRadius=10.0;
    self.textView.layer.borderWidth=1;
    self.textView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.textViewbg.layer.cornerRadius=5.0;
    
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)dismissKeyboard
{
    [_textView resignFirstResponder];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
