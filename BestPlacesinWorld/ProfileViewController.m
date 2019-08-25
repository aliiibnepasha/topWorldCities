//
//  ProfileViewController.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 23/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "ProfileViewController.h"
#import <APMultiMenu.h>
@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftMenu:)];
    self.title = [NSString stringWithFormat:@"Profile"];
    
    self.nameLabel.text=[NSString stringWithFormat:@"Hey, %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
     self.emailLabel.text=[NSString stringWithFormat:@"Your email is %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
    
    self.bgView1.layer.cornerRadius=10.0;
    self.bgView2.layer.cornerRadius=10.0;
    
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

@end
