#import "NMViewController.h"
#import <NMSSH/NMSSH.h>
#import "SquareCamViewController.h"

@interface NMViewController ()

@end

@implementation NMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hostField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"host"];
    self.usernameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    self.authenticationControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"auth"];
}

- (IBAction)authentication:(id)sender {
    self.passwordField.enabled = self.authenticationControl.selectedSegmentIndex == 0;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)login:(id)sender {
    if (self.hostField.text.length == 0 || self.usernameField.text.length == 0 || (self.authenticationControl.selectedSegmentIndex == 0 && self.passwordField.text.length == 0)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"All fields are required!"
                                                           delegate:Nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        NMSSHSession *session = [NMSSHSession connectToHost:self.hostField.text
                                               withUsername:self.usernameField.text];
        
        if (session.isConnected) {
            
                
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            //    NSLog(@"Authentication succeeded");
                
            }
        else{
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error: Connecting to Raspi"
                                                                 message:@"Check the network connection. Try again."
                                                                delegate:Nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [alertError show];
        }
        /*
        NSError *error = nil;
        NSString *response = [session.channel execute:@"ls -l /var/www/" error:&error];
        NSLog(@"List of my sites: %@", response);*/
        
      //  BOOL success = [session.channel uploadFile:@"~/index.html" to:@"/var/www/9muses.se/"];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.hostField.text forKey:@"host"];
        [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:@(self.authenticationControl.selectedSegmentIndex) forKey:@"auth"];
        
        SquareCamViewController *squareController = [segue destinationViewController];
        
        squareController.host = self.hostField.text;
        squareController.username = self.usernameField.text;
        
        if (self.authenticationControl.selectedSegmentIndex == 0) {
            squareController.password = self.passwordField.text;
        }
        else {
            squareController.password = nil;
        }
    }
}


@end
