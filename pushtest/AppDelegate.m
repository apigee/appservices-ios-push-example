#import "AppDelegate.h"
#import "UGClient.h"

@implementation AppDelegate

UGClient * usergridClient;

NSString * baseURL = @"http://10.0.1.20:8080";
NSString * orgName = @"test-organization";
NSString * appName = @"test-app";
NSString * userName = @"scott";
NSString * password = @"password";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // connect and login to App Services
    usergridClient = [[UGClient alloc]initWithOrganizationId: orgName withApplicationID: appName baseURL: baseURL];
    [usergridClient setLogging:true]; //comment out to remove debug output from the console window
    
    [usergridClient logInUser: userName password: password];

    // Register for Push Notifications with Apple
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |
                                                     UIRemoteNotificationTypeAlert |
                                                     UIRemoteNotificationTypeSound];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // register token with App Services
    UGClientResponse *response = [usergridClient setDevicePushToken: newDeviceToken];
    
    if (response.transactionState != kUGClientResponseSuccess) {
        [self alert: response.rawResponse title: @"Error"];
    }
}

- (void)sendMyselfAPushNotification:(NSString *)message
{
    UGClientResponse *response = [usergridClient pushAlert: message
                                                 withSound: @"chime"
                                                        to: @"users/me"
                                             usingNotifier: @"apple"];
    
    if (response.transactionState != kUGClientResponseSuccess) {
        [self alert: response.rawResponse title: @"Error"];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Received a push notification from the server
    // Only pop alert if applicationState is active (if not, the user already saw the alert)
    if (application.applicationState == UIApplicationStateActive)
    {
        NSString * message = [NSString stringWithFormat:@"Text:\n%@",
                              [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        [self alert: message title: @"Remote Notification"];
    }
}

- (void)alert:(NSString *)message title:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle: title
                              message: message
                              delegate: self
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil];
    [alertView show];
}

@end
