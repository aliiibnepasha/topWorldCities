//
//  AddReviewViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 24/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "AddReviewViewController.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <FirebaseDatabase/FIRDatabaseReference.h>
@interface AddReviewViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation AddReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
           self.ref = [[FIRDatabase database] reference];
    _reviewTextView.delegate=self;
    _ratingView.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)dismissKeyboard {
    [_reviewTextView resignFirstResponder];
   
}
- (IBAction)submitButtonTouched:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] isEqualToString:@"Guest"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Signup or Login" subTitle:@"Please signup or Login for this Action" closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    {
    if (_reviewTextView.text.length<1) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Review Text" subTitle:@"Please Add Review." closeButtonTitle:@"OK" duration:0.0f];
    }
    else
    if(_ratingView.value==0)
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Rating" subTitle:@"Please rate the City" closeButtonTitle:@"OK" duration:0.0f];
        
    }
    else
    {
        NSMutableDictionary *reviewdata=[[NSMutableDictionary alloc] init];
        [reviewdata setObject:_reviewTextView.text forKey:@"review"];
         [reviewdata setObject:[NSString stringWithFormat:@"%f",_ratingView.value] forKey:@"rating"];
        [reviewdata setObject:[_citydata objectForKey:@"Name"] forKey:@"Name"];
         [reviewdata setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] forKey:@"username"];
        [reviewdata setObject:[_citydata objectForKey:@"Image"] forKey:@"Image"];
          [reviewdata setObject:[_citydata objectForKey:@"Id"] forKey:@"Id"];
        [[[[[self.ref child:@"users"] child: [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] ] child:@"userreview"] childByAutoId] setValue:@{@"review": reviewdata}];
        
        [[[[[self.ref child:@"Cities"] child:[NSString stringWithFormat:@"%@",[_citydata objectForKey:@"Id"]]] child:@"reviews"] childByAutoId] setValue:@{@"review": reviewdata}];
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert showSuccess:self title:@"Successfully" subTitle:@"added the review" closeButtonTitle:@"OK" duration:0.0f];
        [self.navigationController popViewControllerAnimated:true];
    }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _reviewTextView.text=@"";
    return true;
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
