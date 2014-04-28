//
//  CDAddPersonController.m
//  CoreData7
//
//  Created by John Chen on 4/28/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import "CDAddPersonController.h"

#import "CDAppDelegate.h"
#import "CDPerson.h"

@interface CDAddPersonController ()
@property(nonatomic,weak) IBOutlet UITextField* txtFirstName;
@property(nonatomic,weak) IBOutlet UITextField* txtLastName;
@property(nonatomic,weak) IBOutlet UITextField* txtAge;

@end

@implementation CDAddPersonController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)onSave:(id)sender
{
    CDAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    CDPerson* person = [NSEntityDescription insertNewObjectForEntityForName:@"CDPerson" inManagedObjectContext:managedObjectContext];
    
    if (person) {
        person.firstName = self.txtFirstName.text;
        person.lastName = self.txtLastName.text;
        person.age = @([self.txtAge.text integerValue]);
        
        NSError* error = nil;
        [managedObjectContext save:&error];
        if (error) {
            NSLog(@"save failed - %@",error);
        } else {
            NSLog(@"save person successfully");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        NSLog(@"failed to create person");
    }
}

@end
