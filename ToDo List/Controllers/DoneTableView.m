//
//  DoneTableView.m
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import "DoneTableView.h"
#import "Task.h"
@interface DoneTableView ()

@end
NSUserDefaults*doneDF;
NSData*doneData;
NSMutableArray<Task*>*dnArr;
NSMutableArray*ArrH;
NSMutableArray*ArrM;
NSMutableArray*ArrL;
NSInteger rows;
NSString* secTitle;
UIAlertController*alertDone;
UIAlertAction*cancelDone;
UIAlertAction*okDone;

UIImageView*Dneimgg;
UILabel*DneName;
UILabel*dateDne;
UIView*DneVw;
@implementation DoneTableView


- (void)viewWillAppear:(BOOL)animated{
    doneDF=[NSUserDefaults standardUserDefaults];
    doneData=[doneDF objectForKey:@"Done"];
    NSSet*setDone=[NSSet setWithArray:@[[NSArray class],[Task class]]];
    dnArr=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setDone fromData:doneData error:NULL];
    ArrH=[NSMutableArray new];
    ArrM=[NSMutableArray new];
    ArrL=[NSMutableArray new];
    for (int i=0; i<dnArr.count; i++) {
        if ([dnArr[i].prior isEqual:@"High"]) {
            [ArrH addObject:dnArr[i]];
        }else if ([dnArr[i].prior isEqual:@"Medium"]) {
            [ArrM addObject:dnArr[i]];
        }else if ([dnArr[i].prior isEqual:@"Low"]) {
            [ArrL addObject:dnArr[i]];
        }
    }
    self.tableView.reloadData;

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            rows=ArrH.count;
            break;
        case 1:
            rows=ArrM.count;
            break;
        case 2:
            rows=ArrL.count;
            break;
       
    }
    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            secTitle=@"HIGH";
            break;
        case 1:
            secTitle=@"MEDIUM";
            break;
        case 2:
            secTitle=@"LOW";
            break;
    }
    return secTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    Dneimgg=[cell viewWithTag:2];
    DneName=[cell viewWithTag:3];
    dateDne=[cell viewWithTag:4];
    DneVw=[cell viewWithTag:8];
    [cell addSubview:DneVw];
    
    switch (indexPath.section) {
        case 0:
            DneName.text=[ArrH[indexPath.row] taskName];
            dateDne.text=[NSDateFormatter localizedStringFromDate:[ArrH[indexPath.row] datee]
                                                                                         dateStyle:NSDateFormatterShortStyle
                                                                                         timeStyle:NSDateFormatterShortStyle];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if ([[ArrH[indexPath.row] prior] isEqual:@"High"]) {
                Dneimgg.image=[UIImage imageNamed:@"1"];

            }else if ([[ArrH[indexPath.row] prior] isEqual:@"Medium"]){
                Dneimgg.image=[UIImage imageNamed:@"90"];

            }else if ([[ArrH[indexPath.row] prior] isEqual:@"Low"]){
                Dneimgg.image=[UIImage imageNamed:@"3"];

            }else{
                Dneimgg.image=[UIImage imageNamed:@"10"];
            }
            break;
        case 1:
            DneName.text=[ArrM[indexPath.row] taskName];
            dateDne.text=[NSDateFormatter localizedStringFromDate:[ArrM[indexPath.row] datee]
                                                                     dateStyle:NSDateFormatterShortStyle
                                                                     timeStyle:NSDateFormatterShortStyle];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if ([[ArrM[indexPath.row] prior] isEqual:@"High"]) {
                Dneimgg.image=[UIImage imageNamed:@"high"];

            }else if ([[ArrM[indexPath.row] prior] isEqual:@"Medium"]){
                Dneimgg.image=[UIImage imageNamed:@"medium"];

            }else if ([[ArrM[indexPath.row] prior] isEqual:@"Low"]){
                Dneimgg.image=[UIImage imageNamed:@"low"];

            }else{
                Dneimgg.image=[UIImage imageNamed:@"10"];
            }
            break;
        case 2:
            DneName.text=[ArrL[indexPath.row] taskName];
            dateDne.text=[NSDateFormatter localizedStringFromDate:[ArrL[indexPath.row] datee]
                                                                     dateStyle:NSDateFormatterShortStyle
                                                                     timeStyle:NSDateFormatterShortStyle];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if ([[ArrL[indexPath.row] prior] isEqual:@"High"]) {
                Dneimgg.image=[UIImage imageNamed:@"high"];

            }else if ([[ArrL[indexPath.row] prior] isEqual:@"Medium"]){
                Dneimgg.image=[UIImage imageNamed:@"medium"];

            }else if ([[ArrL[indexPath.row] prior] isEqual:@"Low"]){
                Dneimgg.image=[UIImage imageNamed:@"low"];

            }else{
                Dneimgg.image=[UIImage imageNamed:@"10"];
            }
            break;
        
    }
    DneVw.layer.cornerRadius=30;
    DneVw.layer.shadowColor=[UIColor blackColor].CGColor;
    DneVw.layer.shadowRadius=3;
    DneVw.layer.shadowOpacity=0.5;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        alertDone=[UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure that you want to delete?" preferredStyle:UIAlertControllerStyleAlert];
        cancelDone=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
        okDone=[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            switch (indexPath.section) {
                case 0:
                    [dnArr removeObject:ArrH[indexPath.row]];
                    [ArrH removeObjectAtIndex:indexPath.row];
                    break;
                case 1:
                    [dnArr removeObject:ArrM[indexPath.row]];
                    [ArrM removeObjectAtIndex:indexPath.row];
                    break;
                case 2:
                    [dnArr removeObject:ArrL[indexPath.row]];
                    [ArrL removeObjectAtIndex:indexPath.row];
                    break;
            }
            NSData*dd=[NSKeyedArchiver archivedDataWithRootObject:dnArr requiringSecureCoding:YES error:NULL];
            [doneDF setObject:dd forKey:@"Done"];
            [self.tableView reloadData];
           
        }];
        [alertDone addAction:okDone];
        [alertDone addAction:cancelDone];
        [self presentViewController:alertDone animated:YES completion:NULL];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
       
    }

}


@end
