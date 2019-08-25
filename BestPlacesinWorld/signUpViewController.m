//
//  signUpViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "signUpViewController.h"
#import <FirebaseAuth/FIRAuth.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import <SpinKit/RTSpinKitView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <FirebaseAuth/FIRUser.h>
#import <FirebaseDatabase/FIRDatabaseReference.h>
#import <APMultiMenu/APMultiMenu.h>
@interface signUpViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmpasswordTextfield;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation signUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)dismissKeyboard {
    [_emailTextfield resignFirstResponder];
    [_passwordTextfield resignFirstResponder];
    [_confirmpasswordTextfield resignFirstResponder];
    [_nameTextfield resignFirstResponder];
}
- (IBAction)signupButtonTouched:(id)sender
{
    
    if (_nameTextfield.text.length<1) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:self title:@"Name" subTitle:@"Please enter your name." closeButtonTitle:@"OK" duration:0.0f];
    }
    else
        if (_emailTextfield.text.length<1) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"Email Address" subTitle:@"Please enter the email." closeButtonTitle:@"OK" duration:0.0f];
        }
        else
        if (_passwordTextfield.text.length<1)
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"Password" subTitle:@"Please enter the password." closeButtonTitle:@"OK" duration:0.0f];
        }
        else
            if (_confirmpasswordTextfield.text.length<1)
            {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showError:self title:@"Confirm Password" subTitle:@"Please enter confirm password." closeButtonTitle:@"OK" duration:0.0f];
            }
        else
            if (_confirmpasswordTextfield.text.length<1)
            {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showError:self title:@"Password doesn't Match" subTitle:@"Your Password doesn't match " closeButtonTitle:@"OK" duration:0.0f];
            }
    
        else
        {
            
            RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWanderingCubes color:[UIColor whiteColor]];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.square = YES;
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = spinner;
            hud.labelText = @"Logging in";
            
            [spinner startAnimating];
            
            [[FIRAuth auth] createUserWithEmail:_emailTextfield.text password:_passwordTextfield.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                 [hud hideAnimated:true];
                if (error!=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SCLAlertView *alert = [[SCLAlertView alloc] init];
                        [alert showError:self title:@"Sign up" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
                    });
                    
                    
                }
                else
                {
                
                    [[NSUserDefaults standardUserDefaults] setObject:authResult.user.uid forKey:@"uid"];
                    [[NSUserDefaults standardUserDefaults] setObject:authResult.user.email forKey:@"email"];
                  
                    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextfield.text forKey:@"name"];
                    
                    [[[self.ref child:@"users"] child:authResult.user.uid]
                     setValue:@{@"username": self.emailTextfield.text}];
                    [[[self.ref child:@"users"] child:authResult.user.uid]
                     setValue:@{@"name": self.nameTextfield.text}];
                    [[[self.ref child:@"users"] child:authResult.user.uid]
                     setValue:@{@"password": self.passwordTextfield.text}];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *mainVC = [sb instantiateViewControllerWithIdentifier:@"HomeNav"];
                        UIViewController *leftVC = [sb instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
                        
                        APMultiMenu *apmm = [[APMultiMenu alloc] initWithMainViewController:mainVC
                                                                                   leftMenu:leftVC
                                                                                  rightMenu:nil];
                        
                        apmm.mainViewShadowColor = [UIColor blackColor];
                        apmm.mainViewShadowRadius = 6.0f;
                        apmm.mainViewShadowEnabled = YES;
                        
                        apmm.menuIndentationEnabled = YES;
                        apmm.panGestureEnabled = YES;
                        [self.navigationController pushViewController:apmm animated:true];
                        
                    });
                }
                
               
            }];
            
            
        }
}
- (IBAction)signInButtonTouched:(id)sender
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _emailTextfield) {
        [_emailTextfield resignFirstResponder];
        [_passwordTextfield becomeFirstResponder];
        return NO;
    }
    else
    {
        [_passwordTextfield resignFirstResponder];
        return NO;
    }
    return YES;
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
