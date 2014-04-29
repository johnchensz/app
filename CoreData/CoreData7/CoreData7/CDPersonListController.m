//
//  CDPersonListController.m
//  CoreData7
//
//  Created by John Chen on 4/28/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import "CDPersonListController.h"

#import "CDAppDelegate.h"
#import "CDPerson.h"

static NSString* PersonTableViewCell = @"PersonTableViewCell";

@interface CDPersonListController () <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
@property (weak,nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic,strong) NSFetchedResultsController* frc;
@end



@implementation CDPersonListController

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PersonTableViewCell];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDPerson"];
    NSSortDescriptor* ageSort = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    NSSortDescriptor* firstNameSort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    fetchRequest.sortDescriptors = @[ageSort,firstNameSort];
    
    
    CDAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                   managedObjectContext:managedObjectContext
                                                     sectionNameKeyPath:nil
                                                              cacheName:nil];
    self.frc.delegate = self;
    NSError* error  = nil;
    if ([self.frc performFetch:&error]) {
        NSLog(@"successfully fetched.");
    } else {
        NSLog(@"fetched failed - %@",error);
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addPersonController"]) {
        
    }
}

-(IBAction)onEdit:(id)sender
{
    [self setEditing:YES animated:YES];
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

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type==NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if(type==NSFetchedResultsChangeInsert){
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return sectionInfo.numberOfObjects;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:PersonTableViewCell forIndexPath:indexPath];
    
    CDPerson* person = [self.frc objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [person.firstName stringByAppendingFormat:@" %@",person.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %lu",(unsigned long)[person.age unsignedIntegerValue]];
    return cell;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPerson* person = [self.frc objectAtIndexPath:indexPath];
    
    CDAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    [managedObjectContext deleteObject:person];
    
    if (person.isDeleted) {
        NSError* error = nil;
        if ([managedObjectContext save:&error]) {
            NSLog(@"deleted!!!");
        } else {
            NSLog(@"failed to deleted - %@",error);
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

@end
