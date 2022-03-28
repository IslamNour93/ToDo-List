//
//  AddTaskPage.m
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import "AddTaskPage.h"
#import <CCDropDownMenus/CCDropDownMenus.h>
#import "Task.h"

@interface AddTaskPage ()
@property (weak, nonatomic) IBOutlet UIView *dropListView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *errormsg;


@end

ManaDropDownMenu *menu;
NSString*token;
NSMutableArray*addTaskArr;
NSUserDefaults *defaults;
//NSMutableArray*resultArray;
NSData*savedData;
bool check;
Task*task;
NSData* data;
int i;
//--------- notify
bool isGrandtedNotifyAccess;
NSDateComponents*dateComponent;
@implementation AddTaskPage

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        addTaskArr=[NSMutableArray new];
        printf("init called\n");
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //---------------Notify
    isGrandtedNotifyAccess=false;
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options=UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrandtedNotifyAccess=granted;
    }];
    
    //---------------
    check=false;
    _textView.layer.borderWidth=0.3;
    _textView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
      menu = [[ManaDropDownMenu alloc] initWithFrame:_dropListView.frame title:@"Select Priority"];
      menu.delegate = self;
      menu.numberOfRows = 3;
      menu.textOfRows = @[@"High", @"Medium", @"Low"];
      menu.titleViewColor = [UIColor darkGrayColor];
      menu.activeColor=[UIColor whiteColor];
      menu.inactiveColor = [UIColor whiteColor];
      [self.view addSubview:menu];
      defaults=[NSUserDefaults standardUserDefaults];
      task=[Task new];
}

- (IBAction)saveTask:(id)sender {
    NSError*error;
    if ([_textName.text isEqual:@""]) {
        _errormsg.text=@"Task name is required";
        _errormsg.textColor=[UIColor systemRedColor];
        _errormsg.font=[UIFont boldSystemFontOfSize:14];
    }else if (!check){
        UIAlertController*periortyAlert=[UIAlertController alertControllerWithTitle:@"Hey!" message:@"You must select a priority" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction*k=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:NULL];
        [periortyAlert addAction:k];
        [self presentViewController:periortyAlert animated:YES completion:NULL];
    }
    else{
//        if (_textView.isFocused) {
//            _textView.layer.borderWidth=1;
//            _textView.layer.borderColor=[UIColor blackColor].CGColor;
//        }
    task.taskName=[_textName text];
    task.descrpt=_textView.text;
    task.datee=_datePicker.date;
    task.prior=token;
        
//        [NSDateFormatter localizedStringFromDate:[_datePicker date]
//                                                  dateStyle:NSDateFormatterShortStyle
//                                                  timeStyle:NSDateFormatterShortStyle];
        
            

    
    NSData* dataFirst=[defaults objectForKey:@"Tasks"];
    if (dataFirst==nil) {
        [addTaskArr  addObject:task];
        dataFirst=[NSKeyedArchiver archivedDataWithRootObject:addTaskArr requiringSecureCoding:YES error:&error];
        [defaults setObject:dataFirst forKey:@"Tasks"];
    }
    else
    {
        
    NSSet*set=[NSSet setWithArray:@[[NSMutableArray class],[Task class]]];
    NSMutableArray<Task*>*resultArray=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:dataFirst error:&error];
    [resultArray addObject:task];
    data=[NSKeyedArchiver archivedDataWithRootObject:resultArray requiringSecureCoding:YES error:&error];
    [defaults setObject:data forKey:@"Tasks"];
    printf("%lu\n",(unsigned long)resultArray.count);
        
    }
        if (isGrandtedNotifyAccess) {
            UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent*content=[[UNMutableNotificationContent alloc] init];
            content.title=_textName.text;
            content.subtitle=_textView.text;
            content.body=[NSDateFormatter localizedStringFromDate:[_datePicker date]
                                                                            dateStyle:NSDateFormatterShortStyle
                                                                            timeStyle:NSDateFormatterShortStyle];
            content.sound=[UNNotificationSound defaultSound];
            UNTimeIntervalNotificationTrigger *trigger=[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            // setting up the request for notification
            UNNotificationRequest*request=[UNNotificationRequest requestWithIdentifier:@"localNotify" content:content trigger:trigger];
            [center  addNotificationRequest:request withCompletionHandler:NULL];
        }
    
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    token=menu.textOfRows[index];
    check=true;
}


@end
