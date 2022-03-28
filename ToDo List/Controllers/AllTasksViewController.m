//
//  ViewController.m
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import "AllTasksViewController.h"
#import "AddTaskPage.h"
#import "Task.h"
#import "TaskDetails.h"
@interface AllTasksViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewDo;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *noTasksImage;


@end
AddTaskPage*addTask;
NSString*title;
NSMutableArray<Task*>*displayArr;
TaskDetails*td;
NSMutableArray*newarray;
NSUserDefaults*def;
NSMutableArray<Task*>*filteredTasks;
BOOL isFilter;
UIAlertController*alert;
UIAlertAction*cancel;
UIAlertAction*ok;
UIImageView*pic;
UILabel*tsknme;
UILabel*datename;
UIView*vw;

bool isGrandted;

@implementation AllTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isGrandted=false;
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options=UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrandted=granted;
    }];
    isFilter=NO;
    self.searchBar.delegate=self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    printf("view will appear\n");
    def=[NSUserDefaults standardUserDefaults];
    NSError*error;
    NSData*dataBack=[def objectForKey:@"Tasks"];
    NSSet*sett=[NSSet setWithArray:@[[NSArray class],[Task class]]];
    displayArr=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:sett fromData:dataBack error:&error];
    [self.tableViewDo reloadData];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFilter) {
        if ([filteredTasks count]!=0){
            _tableViewDo.hidden = false;
            _noTasksImage.image = nil;
            _noTasksImage.hidden = true;
        }else{
            _tableViewDo.hidden = true;
            _noTasksImage.image = [UIImage imageNamed:@"notfound"];
            _noTasksImage.hidden = false;
        }
        return filteredTasks.count;
    }else{
        if ([displayArr count]!=0){
            _tableViewDo.hidden = false;
            _noTasksImage.image = nil;
            _noTasksImage.hidden = true;
        }else{
            _tableViewDo.hidden = true;
            _noTasksImage.image = [UIImage imageNamed:@"notasks"];
            _noTasksImage.hidden = false;
        }
        return displayArr.count;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"TASKS";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    pic=[cell viewWithTag:2];
    tsknme=[cell viewWithTag:3];
    datename=[cell viewWithTag:4];
    vw=[cell viewWithTag:5];
    [cell addSubview:vw];
    if (isFilter) {
        tsknme.text=[filteredTasks[indexPath.row] taskName];
        datename.text=[NSDateFormatter localizedStringFromDate:[filteredTasks[indexPath.row] datee]
                                                                 dateStyle:NSDateFormatterShortStyle
                                                                 timeStyle:NSDateFormatterShortStyle];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if ([[filteredTasks[indexPath.row] prior] isEqual:@"High"]) {
            pic.image=[UIImage imageNamed:@"high"];
            

        }else if ([[filteredTasks[indexPath.row] prior] isEqual:@"Medium"]){
            pic.image=[UIImage imageNamed:@"medium"];


        }else if ([[filteredTasks[indexPath.row] prior] isEqual:@"Low"]){
            pic.image=[UIImage imageNamed:@"low"];

        }
        
    }
    else{
    tsknme.text=[displayArr[indexPath.row] taskName];
    datename.text=[NSDateFormatter localizedStringFromDate:[displayArr[indexPath.row] datee]
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterShortStyle];
        
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if ([[displayArr[indexPath.row] prior] isEqual:@"High"]) {
        pic.image=[UIImage imageNamed:@"high"];
        

    }else if ([[displayArr[indexPath.row] prior] isEqual:@"Medium"]){
        pic.image=[UIImage imageNamed:@"medium"];
        


    }else if ([[displayArr[indexPath.row] prior] isEqual:@"Low"]){
        pic.image=[UIImage imageNamed:@"low"];
        
    }
    }
    
        vw.layer.cornerRadius=30;
        vw.layer.shadowColor=[UIColor blackColor].CGColor;
        vw.layer.shadowRadius=3;
        vw.layer.shadowOpacity=0.5;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        alert=[UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
        ok=[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [displayArr removeObjectAtIndex:indexPath.row];
            NSData*dd=[NSKeyedArchiver archivedDataWithRootObject:displayArr requiringSecureCoding:YES error:NULL];
            [def setObject:dd forKey:@"Tasks"];
            [self.tableViewDo reloadData];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:NULL];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    td=[self.storyboard instantiateViewControllerWithIdentifier:@"taskdetail"];
    [td setTaskContainer:displayArr[indexPath.row]];
    [td setIndexRow:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    [self.navigationController pushViewController:td  animated:YES];

}



- (IBAction)addTaskBtn:(id)sender {
    addTask=[self.storyboard instantiateViewControllerWithIdentifier:@"addpage"];
    [self.navigationController pushViewController:addTask animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length == 0) {
        isFilter = NO;
    }
    else {
        isFilter = YES;
        filteredTasks = [[NSMutableArray alloc]init];
        for (int i=0; i<displayArr.count; i++) {
            if ([displayArr[i].taskName hasPrefix:searchText] || [displayArr[i].taskName hasPrefix:[searchText lowercaseString]]) {
                    [filteredTasks addObject:displayArr[i]];
            }
        }
    }
    [self.tableViewDo reloadData];
}


@end
