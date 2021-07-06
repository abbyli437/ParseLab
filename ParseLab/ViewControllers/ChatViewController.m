//
//  ChatViewController.m
//  ParseLab
//
//  Created by Abby Li on 7/6/21.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *chatField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.chatField.placeholder = @"Type a Message...";
    
    //refresh timer
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:true];
    // Do any additional setup after loading the view.
}

- (IBAction)sendTap:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_FBU2021"];
    
    chatMessage[@"text"] = self.chatField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.chatField.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    cell.messageLabel.text = self.messages[indexPath.row][@"text"];
    //cell.messageLabel.layer.borderColor = [UIColor blueColor].CGColor;
    //cell.messageLabel.layer.borderWidth = 1.0;
    
    PFUser *user = self.messages[indexPath.row][@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.usernameLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.usernameLabel.text = @"🤖";
    }
    
    return cell;
}

- (void)refresh {
   // Add code to be run periodically
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_FBU2021"];
    query.limit = 20;
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.messages = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
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
