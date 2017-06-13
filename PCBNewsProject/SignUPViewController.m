//
//  SignUPViewController.m
//  PCBNewsProject
//
//  Created by pawanag on 8/2/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "SignUPViewController.h"
#import "AFNetworking/AFHTTPRequestOperation.h"
#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "ZFacebookUtils.h"
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <GoogleSignIn/GIDGoogleUser.h>
#import <GoogleSignIn/GIDProfileData.h>
#import <GoogleSignIn/GIDAuthentication.h>
#import <GoogleSignIn/GIDSignIn.h>
#import <GoogleSignIn/GIDSignInButton.h>

#import <FBSDKCoreKit/FBSDKGraphRequest.h>

//static NSString * const registrationURLString = @"http://pcbtoday.in/admin/new_app/getIphoneLogin.php?";

//UAT
//static NSString * const registrationURLString = @"http://pcbqa.pcbtoday.in/api/index/registerAppUser";

//PROD
static NSString * const registrationURLString = @"http://pcbtoday.in/api/index/registerAppUser";

@interface SignUPViewController ()<GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, assign) BOOL isRegistrationSuccessful;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end



@implementation SignUPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].clientID = @"487085395060-5vri52md724dkfeb3a4qcbpqetqstjcl.apps.googleusercontent.com";
    self.emailAddress.delegate = self;
    self.contactNumber.delegate = self;
    self.registerButton.enabled = NO;
    self.registerButton.alpha = 0.5;
    self.isRegistrationSuccessful = false;
    
    UITapGestureRecognizer * tapper = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void) loadActivityIndicator {
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setCenter:self.view.center];
    [self.activityIndicator setColor:[UIColor blueColor]];
    [self.view addSubview:self.activityIndicator];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([self.emailAddress isFirstResponder]) {
        [self.view endEditing:YES];
        [self.contactNumber becomeFirstResponder];
    } else if ([self.contactNumber isFirstResponder]) {
        
        [self.view endEditing:YES];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *textFieldText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL shouldEnableContinueButton;
    
    
    if (textFieldText.length > 0) {
        shouldEnableContinueButton = YES;
    }
    if (shouldEnableContinueButton) {
        self.registerButton.enabled = shouldEnableContinueButton;
        self.registerButton.alpha = 1.0;
    } else {
        self.registerButton.enabled = shouldEnableContinueButton;
        self.registerButton.alpha = 0.5;
    }
    
    return YES;
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.isRegistrationSuccessful && [identifier isEqualToString:@"registrationCompleted"]) {
        return YES;
    } else if ([identifier isEqualToString:@"skipIdentifier"]) {
        return YES;
    }
    else return NO;
}

-(void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"registrationCompleted"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        
        SidebarViewController *sbv = [storyboard instantiateViewControllerWithIdentifier:@"SideBarViewController"];
        SWRevealViewController *revealViewController = [[SWRevealViewController alloc]initWithRearViewController:sbv frontViewController:navigationController];
        [self.navigationController presentViewController:revealViewController animated:YES completion:nil];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == [alertView cancelButtonIndex]){
        [self.activityIndicator stopAnimating];
        
    } else {
        [self.activityIndicator stopAnimating];
        [self registerClicked:nil];
    }
}

#pragma Mark Actions

- (IBAction)registerClicked:(id)sender {
    
    //    http://pcbtoday.in/admin/new_app/getIphoneLogin.php?mobile_no=9762800590&
    //    push_id=644d86dcb83f85bcdd809044eaa4b4bc3f7cd63aeff9acedfbb53eb96231a896&email=2312nishant@gmail.com&ver=1.5
    [self loadActivityIndicator];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *deviceTokenDtring = [defaults valueForKey:@"deviceToken"];
    
    //NSString *version= @"1.2";
    
    NSString *partnerSecretKey= @"PCB_SAMAR";
    //NSString *deviceTokenDtring= @"sdbsdmbsd876sdmsbd";
    
    
    //    NSString *registerURL = [NSString stringWithFormat:@"%@mobile_no=%@&push_id=%@&email=%@&ver=%@",registrationURLString,self.contactNumber.text,deviceTokenDtring,self.emailAddress.text,version];
    
    NSString *registerURL = [NSString stringWithFormat:@"partnerSecretKey=%@&email=%@&pushId=%@&mobile=%@&device_type=%@",partnerSecretKey,self.emailAddress.text,deviceTokenDtring,self.contactNumber.text,@"iOS"];
    
    NSURL *url = [NSURL URLWithString:registrationURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[registerURL dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *strResponseStatus=[responseObject objectForKey:@"success"];
        
        if ([strResponseStatus isEqualToString:@"False"] || [strResponseStatus isEqualToString:@"false"]) {
            
            NSString *strResponseDescription=[responseObject objectForKey:@"errorMessage"];
            
            [self.activityIndicator stopAnimating];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mesage"
                                                                message:strResponseDescription
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        else{
            self.isRegistrationSuccessful = true;
            [self performSegueWithIdentifier:@"registrationCompleted" sender:self];
            [self.activityIndicator stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                [defaults setBool:YES forKey:@"Registerd"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.registerButton.enabled = YES;
        self.registerButton.alpha = 1.0;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error While Registering"
                                                            message:[error localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Retry", nil];
        [alertView show];
    }];
    
    [operation start];
    
    self.registerButton.enabled = NO;
    self.registerButton.alpha = 0.5;
}


- (IBAction)skipClicked:(id)sender {
    
    //    http://pcbtoday.in/admin/new_app/getIphoneLogin.php?mobile_no=9762800590&
    //    push_id=644d86dcb83f85bcdd809044eaa4b4bc3f7cd63aeff9acedfbb53eb96231a896&email=2312nishant@gmail.com&ver=1.5
    [self loadActivityIndicator];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *deviceTokenDtring = [defaults valueForKey:@"deviceToken"];
    
    //NSString *version= @"1.2";
    
    NSString *partnerSecretKey= @"PCB_SAMAR";
    //NSString *deviceTokenDtring= @"sdbsdmbsd876sdmsbd";
    
    
    //    NSString *registerURL = [NSString stringWithFormat:@"%@mobile_no=%@&push_id=%@&email=%@&ver=%@",registrationURLString,self.contactNumber.text,deviceTokenDtring,self.emailAddress.text,version];
    
    NSString *registerURL = [NSString stringWithFormat:@"partnerSecretKey=%@&email=%@&pushId=%@&mobile=%@&device_type=%@",partnerSecretKey,self.emailAddress.text,deviceTokenDtring,self.contactNumber.text,@"iOS"];
    
    
    NSURL *url = [NSURL URLWithString:registrationURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[registerURL dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *strResponseStatus=[responseObject objectForKey:@"success"];
        
        if ([strResponseStatus isEqualToString:@"False"] || [strResponseStatus isEqualToString:@"false"]) {
            
            NSString *strResponseDescription=[responseObject objectForKey:@"errorMessage"];
            
            [self.activityIndicator stopAnimating];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mesage"
                                                                message:strResponseDescription
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        else{
            self.isRegistrationSuccessful = true;
            [self performSegueWithIdentifier:@"registrationCompleted" sender:self];
            [self.activityIndicator stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                [defaults setBool:YES forKey:@"Registerd"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.registerButton.enabled = YES;
        self.registerButton.alpha = 1.0;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error While Registering"
                                                            message:[error localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Retry", nil];
        [alertView show];
    }];
    
    [operation start];
    
    self.registerButton.enabled = NO;
    self.registerButton.alpha = 0.5;
}

- (IBAction)fbLoginClicked:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        NSLog(@"Result received is %@", result);
        if ([result.grantedPermissions containsObject:@"email"]) {
            [self getEmailAddressFromFacebook];
        }
    }];
    
}
-(void) getEmailAddressFromFacebook {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSString *email =  [result valueForKey:@"email"];
                 [self loginWithParams:email];
             }
         }];
    }
}

- (IBAction)googleLoginClicked:(id)sender {
    
    [self loadActivityIndicator];
    [[GIDSignIn sharedInstance] signIn];
    //    [self trackCTA:Google_plus];
}

#pragma -mark Google Sign In
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    [self toggleAuthUI:user withError:error];
    
}
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    [self toggleAuthUI:user withError:error];
}
- (void)didTapSignOut{
    [[GIDSignIn sharedInstance] signOut];
    [self toggleAuthUI:nil withError:nil];
}

- (void)didTapDisconnect{
    [[GIDSignIn sharedInstance] disconnect];
}

- (void)toggleAuthUI:(GIDGoogleUser *)googleUser
           withError:(NSError *)error {
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
        // Not signed in
        
    } else {
        
        
//        NSString *accessToken = [[googleUser authentication] accessToken];
//        NSDictionary * params = @{@"service" : @"google",
//                                  @"auth_token" : accessToken} ;
//        
        NSString *email = googleUser.profile.email;
//        NSString *name = googleUser.profile.name;
        [self loginWithParams:email];
    }
}

-(void) loginWithParams :(NSString*)email  {
    
    [self loadActivityIndicator];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceTokenDtring = [defaults valueForKey:@"deviceToken"];
    
    NSString *version= @"1.2";
    NSString *registerURL = [NSString stringWithFormat:@"%@push_id=%@&email=%@&ver=%@",registrationURLString,deviceTokenDtring,email,version];
    //    NSLog(@"Register URL is %@", registerURL);
    
    NSURL *url = [NSURL URLWithString:registerURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"Success");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [defaults setBool:YES forKey:@"Registerd"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
        
        self.isRegistrationSuccessful = true;
        [self performSegueWithIdentifier:@"registrationCompleted" sender:self];
        [self.activityIndicator stopAnimating];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [defaults setBool:NO forKey:@"Registerd"];
            [defaults synchronize];
        });
    }];
    
//    self.isRegistrationSuccessful = true;
//    [self performSegueWithIdentifier:@"registrationCompleted" sender:self];
//    [self.activityIndicator stopAnimating];
    
    [operation start];
    
    self.registerButton.enabled = NO;
    self.googleLoginButton.enabled = NO;
    //    self.registerButton.alpha = 0.5;
}
@end
