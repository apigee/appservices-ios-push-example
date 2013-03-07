#import "ViewController.h"
#import "AppDelegate.h"
#import "UGClient.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView;

UGClient * usergridClient;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * baseURL  = @"http://10.0.1.20:8080";
    NSString * orgName  = @"test-organization";
    NSString * appName  = @"test-app";
    NSString * userName = @"scott";
    NSString * password = @"password";
    
    // connect and login to App Services
    usergridClient = [[UGClient alloc]initWithOrganizationId: orgName withApplicationID: appName baseURL: baseURL];
    [usergridClient setLogging:true]; //comment out to remove debug output from the console window
    [usergridClient logInUser: userName password: password];
}

- (IBAction)buttonTouch:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate sendMyselfAPushNotification: @"You pushed the button!"];
}
@end
