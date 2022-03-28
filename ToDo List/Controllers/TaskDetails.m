//
//  TaskDetails.m
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import "TaskDetails.h"
#import "Task.h"
#import "AllTasksViewController.h"
#import <CCDropDownMenus/CCDropDownMenus.h>
#import "InProgressTableView.h"

@interface TaskDetails ()
@property (weak, nonatomic) IBOutlet UITextField *editName;
@property (weak, nonatomic) IBOutlet UITextView *editDescp;
@property (weak, nonatomic) IBOutlet UIView *editPer;
@property (weak, nonatomic) IBOutlet UIDatePicker *editDateee;

@end
ManaDropDownMenu *menuu;
NSString*tok;
NSUserDefaults*dfEdit;
NSUserDefaults*dfEdit2;
NSMutableArray<Task*>*arr;
NSMutableArray*array;
NSMutableArray*rsArr;
NSMutableArray<Task*>*doneArr;
NSData*dataBack;
NSData*databack2;
NSData*dataDone;
NSData*dataDone2;
NSSet*sett;
bool change;
InProgressTableView*inProg;
@implementation TaskDetails

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        array=[NSMutableArray new];
        doneArr=[NSMutableArray new];
        printf("init called\n");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    dfEdit=[NSUserDefaults standardUserDefaults];
    dataBack=[dfEdit objectForKey:@"Tasks"];
    sett=[NSSet setWithArray:@[[NSArray class],[Task class]]];
    arr=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:sett fromData:dataBack error:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    change=false;
    _editDescp.layer.borderWidth=0.3;
    _editDescp.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _editDescp.text=_taskContainer.descrpt;
    _editDateee.date=_taskContainer.datee;
    _editName.text=_taskContainer.taskName;
    menuu = [[ManaDropDownMenu alloc] initWithFrame:_editPer.frame title:_taskContainer.prior];
    menuu.delegate = self;
    menuu.numberOfRows = 3;
    menuu.textOfRows = @[@"High", @"Medium", @"Low"];
    menuu.titleViewColor = [UIColor blackColor];
    menuu.activeColor=[UIColor whiteColor];
    menuu.inactiveColor = [UIColor whiteColor];
    dfEdit2=[NSUserDefaults standardUserDefaults];
    [self.view addSubview:menuu];
   
}

- (IBAction)addToProg:(id)sender {
    
    Task*tsk=[Task new];
        tsk.taskName=_editName.text;
    if (change) {
        tsk.prior=tok;
    }else{
        tsk.prior=_taskContainer.prior;
    }
        
        tsk.descrpt=_editDescp.text;
        tsk.datee=_editDateee.date;
    
    [arr removeObjectAtIndex:_indexRow];
    dataBack=[NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:NULL];
    [dfEdit setObject:dataBack forKey:@"Tasks"];
    
    NSData* dataFirst=[dfEdit objectForKey:@"inProgress"];
    if (dataFirst==nil) {
        [array  addObject:tsk];
        dataFirst=[NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:NULL];
        [dfEdit setObject:dataFirst forKey:@"inProgress"];
    }
    else
    {
        
    NSSet*set=[NSSet setWithArray:@[[NSMutableArray class],[Task class]]];
    NSMutableArray<Task*>*resultArray=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:dataFirst error:NULL];
    [resultArray addObject:tsk];
    databack2=[NSKeyedArchiver archivedDataWithRootObject:resultArray requiringSecureCoding:YES error:NULL];
    [dfEdit setObject:databack2 forKey:@"inProgress"];
    printf("%lu\n",(unsigned long)resultArray.count);
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addToDone:(id)sender {
    Task*tsk2=[Task new];
        tsk2.taskName=_editName.text;
    if (change) {
        tsk2.prior=tok;
    }else{
        tsk2.prior=_taskContainer.prior;
    }
        tsk2.descrpt=_editDescp.text;
        tsk2.datee=_editDateee.date;
    [arr removeObjectAtIndex:_indexRow];
    dataBack=[NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:NULL];
    [dfEdit setObject:dataBack forKey:@"Tasks"];
    
    dataDone=[dfEdit objectForKey:@"Done"];
    if (dataDone==nil) {
        [doneArr addObject:tsk2];
        dataDone=[NSKeyedArchiver archivedDataWithRootObject:doneArr requiringSecureCoding:YES error:NULL];
        [dfEdit setObject:dataDone forKey:@"Done"];
    }else
    {
        NSSet*s=[NSSet setWithArray:@[[NSMutableArray class],[Task class]]];
        NSMutableArray<Task*>*resultDoneArray=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:s fromData:dataDone error:NULL];
        [resultDoneArray addObject:tsk2];
        dataDone2=[NSKeyedArchiver archivedDataWithRootObject:resultDoneArray requiringSecureCoding:YES error:NULL];
        [dfEdit setObject:dataDone2 forKey:@"Done"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)doneTask:(id)sender {
  
    [[arr objectAtIndex:_indexRow] setTaskName:_editName.text];
    [[arr objectAtIndex:_indexRow] setDescrpt:_editDescp.text];
    if (change) {
        [[arr objectAtIndex:_indexRow] setPrior:tok];
    }else{
        [[arr objectAtIndex:_indexRow] setPrior:_taskContainer.prior];
    }
    [[arr objectAtIndex:_indexRow] setDatee:_editDateee.date];
    
    dataBack=[NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:NULL];
    [dfEdit setObject:dataBack forKey:@"Tasks"];
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    tok=menuu.textOfRows[index];
    change=true;
}


@end
