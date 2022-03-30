//
//  InProgressTableView.m
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import "InProgressTableView.h"
#import "Task.h"
#import "TaskDetails.h"
#import "DetailsFromInProgress.h"

@interface InProgressTableView ()

@end
NSUserDefaults*progressDF;
NSData*progressData;
NSMutableArray<Task*>*progArr;
TaskDetails*taskDet;
NSMutableArray<Task*>*ArrHigh;
NSMutableArray<Task*>*ArrMed;
NSMutableArray<Task*>*ArrLow;
NSInteger numOfRows;
NSString *perTitle;
UIAlertController*deleteAlert;
UIAlertAction*cancel2;
UIAlertAction*ok2;
bool sorted;
//-------------- cell
UIImageView*imgg;
UILabel*prgName;
UILabel*datePrognm;
UIView*prgVw;

@implementation InProgressTableView

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        progArr=[NSMutableArray new];
        printf("init called\n");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    printf("in progress view will appear\n");
    progressDF=[NSUserDefaults standardUserDefaults];
    progressData=[progressDF objectForKey:@"inProgress"];
    NSSet*setprog=[NSSet setWithArray:@[[NSArray class],[Task class]]];
    progArr=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setprog  fromData:progressData error:NULL];
    ArrHigh=[NSMutableArray new];
    ArrMed=[NSMutableArray new];
    ArrLow=[NSMutableArray new];
    int x=0;
    int y=0;
    int z=0;
    for (int i=0; i<progArr.count; i++) {
        
//        progArr[i].idd=i;
        if ([progArr[i].prior isEqual:@"High"]) {
            [ArrHigh addObject:progArr[i]];
            [progArr[x] setIdd:i];
            x++;
        }else if ([progArr[i].prior isEqual:@"Medium"]) {
            [ArrMed addObject:progArr[i]];
            [progArr[y] setIdd:i];
            y++;
        }else if ([progArr[i].prior isEqual:@"Low"]) {
            [ArrLow addObject:progArr[i]];
            [progArr[z] setIdd:i];
            z++;
        }
        
    }
    self.tableView.reloadData;
    

}
- (IBAction)sortingButton:(id)sender {
    sorted=!sorted;
    self.tableView.reloadData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sorted=NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sorted) {
        switch (section) {
            case 2:
                numOfRows=ArrHigh.count;
                break;
            case 1:
                numOfRows=ArrMed.count;
                break;
            case 0:
                numOfRows=ArrLow.count;
                break;
            
        }
    }else{
    
    switch (section) {
        case 0:
            numOfRows=ArrHigh.count;
            break;
        case 1:
            numOfRows=ArrMed.count;
            break;
        case 2:
            numOfRows=ArrLow.count;
            break;
        
    }
        
    }
    return numOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (sorted) {
        switch (section) {
            case 2:
                perTitle=@"HIGH";
                break;
            case 1:
                perTitle=@"MEDIUM";
                break;
            case 0:
                perTitle=@"LOW";
                break;
        }
    }else{
    switch (section) {
        case 0:
            perTitle=@"HIGH";
            break;
        case 1:
            perTitle=@"MEDIUM";
            break;
        case 2:
            perTitle=@"LOW";
            break;
    }
        
    }
    return perTitle;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    imgg=[cell viewWithTag:2];
    prgName=[cell viewWithTag:3];
    datePrognm=[cell viewWithTag:4];
    prgVw=[cell viewWithTag:5];
    [cell addSubview:prgVw];
    
    if (sorted) {
        switch (indexPath.section) {
            case 2:
                prgName.text=[ArrHigh[indexPath.row] taskName];
                datePrognm.text=[NSDateFormatter localizedStringFromDate:[ArrHigh[indexPath.row] datee]
                                                                         dateStyle:NSDateFormatterShortStyle
                                                                         timeStyle:NSDateFormatterShortStyle];
                
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                if ([[ArrHigh[indexPath.row] prior] isEqual:@"High"]) {
                    imgg.image=[UIImage imageNamed:@"high"];


                }else if ([[ArrHigh[indexPath.row] prior] isEqual:@"Medium"]){
                    imgg.image=[UIImage imageNamed:@"medium"];


                }else if ([[ArrHigh[indexPath.row] prior] isEqual:@"Low"]){
                    imgg.image=[UIImage imageNamed:@"low"];

                }
                break;
            case 1:
                prgName.text=[ArrMed[indexPath.row] taskName];
                datePrognm.text=[NSDateFormatter localizedStringFromDate:[ArrMed[indexPath.row] datee]
                                                                         dateStyle:NSDateFormatterShortStyle
                                                                         timeStyle:NSDateFormatterShortStyle];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                if ([[ArrMed[indexPath.row] prior] isEqual:@"High"]) {
                    imgg.image=[UIImage imageNamed:@"high"];

                }else if ([[ArrMed[indexPath.row] prior] isEqual:@"Medium"]){
                    imgg.image=[UIImage imageNamed:@"medium"];

                }else if ([[ArrMed[indexPath.row] prior] isEqual:@"Low"]){
                    imgg.image=[UIImage imageNamed:@"low"];

                }
                break;
            case 0:
                prgName.text=[ArrLow[indexPath.row] taskName];
                datePrognm.text=[NSDateFormatter localizedStringFromDate:[ArrLow[indexPath.row] datee]
                                                                         dateStyle:NSDateFormatterShortStyle
                                                                         timeStyle:NSDateFormatterShortStyle];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                if ([[ArrLow[indexPath.row] prior] isEqual:@"High"]) {
                    imgg.image=[UIImage imageNamed:@"high"];

                }else if ([[ArrLow[indexPath.row] prior] isEqual:@"Medium"]){
                    imgg.image=[UIImage imageNamed:@"medium"];

                }else if ([[ArrLow[indexPath.row] prior] isEqual:@"Low"]){
                    imgg.image=[UIImage imageNamed:@"low"];

                }
                break;
        }
    }else{
    
    switch (indexPath.section) {
        case 0:
            prgName.text=[ArrHigh[indexPath.row] taskName];
            datePrognm.text=[NSDateFormatter localizedStringFromDate:[ArrHigh[indexPath.row] datee]
                                                                     dateStyle:NSDateFormatterShortStyle
                                                                     timeStyle:NSDateFormatterShortStyle];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if ([[ArrHigh[indexPath.row] prior] isEqual:@"High"]) {
                imgg.image=[UIImage imageNamed:@"high"];


            }else if ([[ArrHigh[indexPath.row] prior] isEqual:@"Medium"]){
                imgg.image=[UIImage imageNamed:@"medium"];


            }else if ([[ArrHigh[indexPath.row] prior] isEqual:@"Low"]){
                imgg.image=[UIImage imageNamed:@"low"];

            }
            break;
        case 1:
            prgName.text=[ArrMed[indexPath.row] taskName];
            datePrognm.text=[NSDateFormatter localizedStringFromDate:[ArrMed[indexPath.row] datee]
                                                                     dateStyle:NSDateFormatterShortStyle
                                                                     timeStyle:NSDateFormatterShortStyle];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if ([[ArrMed[indexPath.row] prior] isEqual:@"High"]) {
                imgg.image=[UIImage imageNamed:@"high"];

            }else if ([[ArrMed[indexPath.row] prior] isEqual:@"Medium"]){
                imgg.image=[UIImage imageNamed:@"medium"];

            }else if ([[ArrMed[indexPath.row] prior] isEqual:@"Low"]){
                imgg.image=[UIImage imageNamed:@"low"];

            }
            break;
        case 2:
            prgName.text=[ArrLow[indexPath.row] taskName];
            datePrognm.text=[NSDateFormatter localizedStringFromDate:[ArrLow[indexPath.row] datee]
                                                                     dateStyle:NSDateFormatterShortStyle
                                                                     timeStyle:NSDateFormatterShortStyle];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if ([[ArrLow[indexPath.row] prior] isEqual:@"High"]) {
                imgg.image=[UIImage imageNamed:@"high"];

            }else if ([[ArrLow[indexPath.row] prior] isEqual:@"Medium"]){
                imgg.image=[UIImage imageNamed:@"medium"];

            }else if ([[ArrLow[indexPath.row] prior] isEqual:@"Low"]){
                imgg.image=[UIImage imageNamed:@"low"];

            }
            break;
    }}
    prgVw.layer.cornerRadius=30;
    prgVw.layer.shadowColor=[UIColor blackColor].CGColor;
    prgVw.layer.shadowRadius=3;
    prgVw.layer.shadowOpacity=0.5;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteAlert=[UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure that you want to delete?" preferredStyle:UIAlertControllerStyleAlert];
        cancel2=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
        ok2=[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (sorted) {
                switch (indexPath.section) {
                    case 2:
                        [progArr removeObject:ArrHigh[indexPath.row]];
                        [ArrHigh removeObjectAtIndex:indexPath.row];
                        break;
                    case 1:
                        [progArr removeObject:ArrMed[indexPath.row]];
                        [ArrMed removeObjectAtIndex:indexPath.row];
                        break;
                    case 0:
                        [progArr removeObject:ArrLow[indexPath.row]];
                        [ArrLow removeObjectAtIndex:indexPath.row];

                        break;
                }
            }else{
                switch (indexPath.section) {
                    case 0:
                        [progArr removeObject:ArrHigh[indexPath.row]];
                        [ArrHigh removeObjectAtIndex:indexPath.row];
                        break;
                    case 1:
                        [progArr removeObject:ArrMed[indexPath.row]];
                        [ArrMed removeObjectAtIndex:indexPath.row];
                        break;
                    case 2:
                        [progArr removeObject:ArrLow[indexPath.row]];
                        [ArrLow removeObjectAtIndex:indexPath.row];

                        break;
                }
            }
            
            
            NSData*dd=[NSKeyedArchiver archivedDataWithRootObject:progArr requiringSecureCoding:YES error:NULL];
            [progressDF setObject:dd forKey:@"inProgress"];
            [self.tableView reloadData];
           
        }];
        [deleteAlert addAction:ok2];
        [deleteAlert addAction:cancel2];
        [self presentViewController:deleteAlert animated:YES completion:NULL];
        
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsFromInProgress *editTaskProg
=[self.storyboard instantiateViewControllerWithIdentifier:@"taskdetailprog"];
    if (sorted) {
        switch (indexPath.section) {
            case 2:
                for (int i=0; i<progArr.count; i++) {
                    if (progArr[i].idd==ArrHigh[indexPath.row].idd) {
                        [editTaskProg setContTask:ArrHigh[indexPath.row]];
                        [editTaskProg setRowIndx:i];
                    }
                }
                break;
            case 1:
                for (int i=0; i<progArr.count; i++) {
                    if (progArr[i].idd==ArrMed[indexPath.row].idd) {
                        [editTaskProg setContTask:ArrMed[indexPath.row]];
                        [editTaskProg setRowIndx:i];
                    }
                }
                break;
            case 0:
                for (int i=0; i<progArr.count; i++) {
                    if (progArr[i].idd==ArrLow[indexPath.row].idd) {
                        [editTaskProg setContTask:ArrLow[indexPath.row]];
                        [editTaskProg setRowIndx:i];
                    }
                }
                break;
            default:
                break;
                
        }
    }else{
    switch (indexPath.section) {
        case 0:
            for (int i=0; i<progArr.count; i++) {
                if (progArr[i].idd==ArrHigh[indexPath.row].idd) {
                    [editTaskProg setContTask:ArrHigh[indexPath.row]];
                    [editTaskProg setRowIndx:i];
                }
            }
            break;
        case 1:
            for (int i=0; i<progArr.count; i++) {
                if (progArr[i].idd==ArrMed[indexPath.row].idd) {
                    [editTaskProg setContTask:ArrMed[indexPath.row]];
                    [editTaskProg setRowIndx:i];
                }
            }
            break;
        case 2:
            for (int i=0; i<progArr.count; i++) {
                if (progArr[i].idd==ArrLow[indexPath.row].idd) {
                    [editTaskProg setContTask:ArrLow[indexPath.row]];
                    [editTaskProg setRowIndx:i];
                }
            }
            break;
        default:
            break;
            
    }}
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    [self.navigationController pushViewController:editTaskProg animated:YES];
}

@end
