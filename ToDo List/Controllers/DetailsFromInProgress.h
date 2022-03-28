//
//  DetailsFromInProgress.h
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import <CCDropDownMenus/CCDropDownMenus.h>

@interface DetailsFromInProgress : UIViewController <CCDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UITextField *progressDetailName;
@property (weak, nonatomic) IBOutlet UITextView *progressDetailDesc;
@property (weak, nonatomic) IBOutlet UIView *progressDetailPrio;
@property (weak, nonatomic) IBOutlet UIDatePicker *progressDetailDate;

@property NSInteger rowIndx;
@property Task*ContTask;
@end

