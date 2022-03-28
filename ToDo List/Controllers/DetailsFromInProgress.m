//
//  DetailsFromInProgress.m
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import "DetailsFromInProgress.h"
#import <CCDropDownMenus/CCDropDownMenus.h>

@interface DetailsFromInProgress ()

@end
ManaDropDownMenu *menuu2;
NSString*tk;
NSUserDefaults*dfProg;
NSMutableArray<Task*>*arrayOfPG;
NSData*dataPGBack;
NSData*bringData;
NSSet*pgSet;
NSString*choose;
bool ch;
//-----------
NSMutableArray<Task*>*toDoneArr;
NSData*toDoneData;
@implementation DetailsFromInProgress

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        toDoneArr=[NSMutableArray new];
        printf("init called\n");
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    dfProg=[NSUserDefaults standardUserDefaults];
    dataPGBack=[dfProg objectForKey:@"inProgress"];
    pgSet=[NSSet setWithArray:@[[NSArray class],[Task class]]];
    arrayOfPG=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:pgSet fromData:dataPGBack error:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ch=false;
    _progressDetailDesc.layer.borderWidth=0.3;
    _progressDetailDesc.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _progressDetailPrio.layer.borderWidth=0.5;
    _progressDetailPrio.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    _progressDetailDesc.text=_ContTask.descrpt;
    _progressDetailDate.date=_ContTask.datee;
    _progressDetailName.text=_ContTask.taskName;
    menuu2 = [[ManaDropDownMenu alloc] initWithFrame:_progressDetailPrio.frame title:_ContTask.prior];
    menuu2.delegate = self;
    menuu2.numberOfRows = 3;
    menuu2.textOfRows = @[@"High", @"Medium", @"Low"];
    menuu2.titleViewColor = [UIColor blackColor];
    menuu2.activeColor=[UIColor whiteColor];
    menuu2.inactiveColor = [UIColor whiteColor];
    dfProg=[NSUserDefaults standardUserDefaults];
    [self.view addSubview:menuu2];
}


- (IBAction)edtButton:(id)sender {
    [[arrayOfPG objectAtIndex:_rowIndx] setTaskName:_progressDetailName.text];
    [[arrayOfPG objectAtIndex:_rowIndx] setDescrpt:_progressDetailDesc.text];
    [[arrayOfPG objectAtIndex:_rowIndx] setDatee:_progressDetailDate.date];
    if (ch) {
        [[arrayOfPG objectAtIndex:_rowIndx] setPrior:choose];

    }else{
        [[arrayOfPG objectAtIndex:_rowIndx] setPrior:_ContTask.prior];
    }
    bringData=[NSKeyedArchiver archivedDataWithRootObject:arrayOfPG requiringSecureCoding:YES error:NULL];
    [dfProg setObject:bringData forKey:@"inProgress"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fromProgToDone:(id)sender {
    Task*DoneTask=[Task new];
    DoneTask.taskName=_progressDetailName.text;
    DoneTask.descrpt=_progressDetailDesc.text;
    DoneTask.datee=_progressDetailDate.date;
    if (ch) {
        DoneTask.prior=choose;
    }else{
        DoneTask.prior=_ContTask.prior;
    }
    [arrayOfPG removeObjectAtIndex:_rowIndx];
    dataPGBack=[NSKeyedArchiver archivedDataWithRootObject:arrayOfPG requiringSecureCoding:YES error:NULL];
    [dfProg setObject:dataPGBack forKey:@"inProgress"];
    
    toDoneData=[dfProg objectForKey:@"Done"];
    
    if (toDoneData==nil) {
        [toDoneArr addObject:DoneTask];
        toDoneData=[NSKeyedArchiver archivedDataWithRootObject:toDoneArr requiringSecureCoding:YES error:NULL];
        [dfProg setObject:toDoneData forKey:@"Done"];
    }else
    {
        NSSet*toDoneSet=[NSSet setWithArray:@[[NSMutableArray class],[Task class]]];
        NSMutableArray<Task*>*doneArray=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:toDoneSet fromData:toDoneData error:NULL];
        [doneArray addObject:DoneTask];
        NSData*rr=[NSKeyedArchiver archivedDataWithRootObject:doneArray requiringSecureCoding:YES error:NULL];
        [dfProg setObject:rr forKey:@"Done"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index{
    choose=menuu2.textOfRows[index];
    ch=true;
}

@end
