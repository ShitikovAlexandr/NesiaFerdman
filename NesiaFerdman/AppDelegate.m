//
//  AppDelegate.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 2017 4/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "AppDelegate.h"
#import "NFStyleKit.h"
#import "NFGoogleSyncManager.h"
#import "NFNSyncManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Reachability.h"
#import "NFStatisticPageController.h"
@import Firebase;

#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@interface AppDelegate ()
@property (strong, nonatomic) Reachability *reachability;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [Fabric with:@[[Crashlytics class]]];
    [FIRApp configure];
    
    [self setNFStyleAndColors];
    [self reachabilityNetwork];
    [NFGoogleSyncManager sharedManager];
    [self registerPushNotifications];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"UIApplicationStateActive");
    } else if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"UIApplicationStateBackground");
        [defaults setValue:PUSH_ACTION_VALUE forKey:PUSH_ACTION_KEY];
    } else if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"UIApplicationStateInactive");
        [defaults setValue:PUSH_ACTION_VALUE forKey:PUSH_ACTION_KEY];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([[NFGoogleSyncManager sharedManager] isLogin]) {
        //[ROOTVIEW presentViewController:interstitialViewController animated:YES completion:^{}];
        [self presentStatistic];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)presentStatistic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pushData = [defaults objectForKey:PUSH_ACTION_KEY];
    if ([pushData isEqualToString:PUSH_ACTION_VALUE]) {
        [ROOTVIEW.presentedViewController dismissViewControllerAnimated:YES completion:^{
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [defaults setValue:@"no" forKey:PUSH_ACTION_KEY];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NFStatisticPageController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFStatisticPageController"];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFStatisticPageControllerNav"];
            [navController setViewControllers:@[viewController]];
            [ROOTVIEW presentViewController:navController animated:YES completion:nil];
            
        });
    }
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"NesiaFerdman"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - StyleAndColors 

- (void)setNFStyleAndColors {

    [[UITabBar appearance] setBarTintColor:[NFStyleKit bASE_GREEN]];

    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateSelected];
    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:184/255.0 green:216/255.0 blue:187/255.0 alpha:1]}
                                           forState:UIControlStateNormal];
    [UITabBar.appearance setBackgroundColor:[NFStyleKit bASE_GREEN]];
    [UITabBar.appearance setTranslucent:NO];
    [UITabBar.appearance setTintColor:[UIColor whiteColor]];
    
    [UINavigationBar.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setBarTintColor:[NFStyleKit bASE_GREEN]];
    [UINavigationBar.appearance setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //cell
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [[NFStyleKit bASE_GREEN] colorWithAlphaComponent:0.2];
    [UITableViewCell appearance].selectedBackgroundView = bgColorView;
}

- (void)reachabilityNetwork {
    // Initialize Reachability
    _reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    // Start Monitoring
    [_reachability startNotifier];
}

#pragma mark - Firebase Massage

- (void)registerPushNotifications {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"PUSH GRANTED %@", @(granted));
        }];
        
        // For iOS 10 display notification (sent via APNS)
        //[UNUserNotificationCenter currentNotificationCenter].delegate = self;
        // For iOS 10 data message (sent via FCM)
        [FIRMessaging messaging].remoteMessageDelegate = self;
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    if (refreshedToken !=nil) {
        //[[NFNSyncManager sharedManager] updateFIRToken:refreshedToken];
    }
   // [[NSUserDefaults standardUserDefaults] setValue:refreshedToken forKey:PUSH_TOKEN];
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
    
}

- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}






//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
//        UIUserNotificationType allNotificationTypes =
//        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings =
//        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        // iOS 10 or later
//#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//        // For iOS 10 display notification (sent via APNS)
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//        UNAuthorizationOptions authOptions =
//        UNAuthorizationOptionAlert
//        | UNAuthorizationOptionSound
//        | UNAuthorizationOptionBadge;
//        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        }];
//#endif
//    }
//    
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
//    if (userInfo[kGCMMessageIDKey]) {
//        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
//    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}


// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", [remoteMessage appData]);
}
#endif
// [END ios_10_data_message_handling]


@end
