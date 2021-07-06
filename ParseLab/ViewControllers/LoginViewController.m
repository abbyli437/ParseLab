//
//  LoginViewController.m
//  ParseLab
//
//  Created by Abby Li on 7/6/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameTextField.placeholder = @"Username";
    self.passwordTextField.placeholder = @"Password";
    // Do any additional setup after loading the view.
}

- (IBAction)signUpTap:(id)sender {
    //set up alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Sign Up"
                                                                               message:@"Username or Password field is blank"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    if ([self.usernameTextField.text isEqual:@""] || [self.passwordTextField.text isEqual:@""]) {
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    else {
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameTextField.text;
        //newUser.email = @"hello@gmail.com"; //self.emailField.text;
        newUser.password = self.passwordTextField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                alert.message = [@"Error: " stringByAppendingString:error.localizedDescription];
                [self presentViewController:alert animated:YES completion:^{
                }];
                
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)logInTap:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Log in"
                                                                                       message:[@"Error: " stringByAppendingString:error.localizedDescription]
                                                                                preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            //show alert
            [self presentViewController:alert animated:YES completion:^{
            }];
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
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
