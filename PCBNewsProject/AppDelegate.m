//
//  AppDelegate.m
//  PCBNewsProject
//
//  Created by pawanag on 4/15/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailListingViewViewController.h"
#import "DetailViewController.h"
#import "NewsModelClass.h"
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import <Google/SignIn.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>

NSString * const zGooglePlusSignInUrlScheme = @"com.googleusercontent.apps.487085395060-5vri52md724dkfeb3a4qcbpqetqstjcl";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    BOOL isRegistered =  [defaults boolForKey:@"Registerd"];
    if (isRegistered) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        
        
        SidebarViewController *sbv = [storyboard instantiateViewControllerWithIdentifier:@"SideBarViewController"];
        SWRevealViewController *revealViewController = [[SWRevealViewController alloc]initWithRearViewController:sbv frontViewController:navigationController];
        _window.rootViewController = revealViewController;
    }
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    //--- your custom code
    return YES;
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"fb879221585503975"]){
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
        
    }else if ([[url scheme] isEqualToString:zGooglePlusSignInUrlScheme]){
        return   [[GIDSignIn sharedInstance] handleURL:url
                                     sourceApplication:sourceApplication
                                            annotation:annotation];
    }
    
    return NO;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString* deviceTokenString = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];

//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:deviceTokenString message:deviceTokenString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:deviceTokenString forKey:@"deviceToken"];
    [defaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
}



- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSDictionary *aPayload;
    
    NSLog(@"%@",userInfo);
    
    if ([userInfo objectForKey:@"aps"]) {
        aPayload= [userInfo objectForKey:@"aps"];
    }
    
    NewsModelClass *newsModelClass = [[NewsModelClass alloc]init];
    if ([aPayload objectForKey:@"alert"])
    {
        newsModelClass.newsTitle = [aPayload objectForKey:@"alert"];
    }
//    if ([aPayload objectForKey:@"description"]) {
//        newsModelClass.newsDescription = [aPayload objectForKey:@"description"];
//    }
//    if ([aPayload objectForKey:@"link"]) {
//        newsModelClass.newsImageUrl = [aPayload objectForKey:@"link"];
//    }

    if ([aPayload objectForKey:@"id"])
    {
        newsModelClass.newsId = [aPayload objectForKey:@"id"];
    }
    
 
    
    NSString *message = nil;
    NSString* alert = [aPayload objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSString class]])
    {
        message = alert;
    }
    UIApplicationState state = [application applicationState];
    if (alert && UIApplicationStateActive == state)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"News Flash"
                                                            message:message delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    } else
    {
        [self navigateToNotificationScreen:newsModelClass];
    }
}

-(void) navigateToNotificationScreen : (NewsModelClass*) newsModelClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    
    SidebarViewController *sbv = [storyboard instantiateViewControllerWithIdentifier:@"SideBarViewController"];
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc]initWithRearViewController:sbv frontViewController:navigationController];
    DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    _window.rootViewController = revealViewController;
    
    detailViewController.newsModelClass = newsModelClass;
    detailViewController.newsCategoryString = @"Notifications";
    detailViewController.isNotification = @"Notification";
    [navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pawan.PCBNewsProject" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PCBNewsProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PCBNewsProject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
        }
    }
}

@end
