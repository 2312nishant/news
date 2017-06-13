//
//  SignUPViewController.h
//  PCBNewsProject
//
//  Created by pawanag on 8/2/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUPViewController : UITableViewController<UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *contactNumber;
//@property (weak, nonatomic) IBOutlet UITextField *gender;
- (IBAction)registerClicked:(id)sender;
- (IBAction)skipClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *googleLoginButton;
- (IBAction)googleLoginClicked:(id)sender;

@end
