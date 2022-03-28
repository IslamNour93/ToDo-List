//
//  ViewController.h
//  ToDo
//
//  Created by Islam NourEldin on 28/01/2022.
//

#import <UIKit/UIKit.h>
@interface AllTasksViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addTask;



@end

