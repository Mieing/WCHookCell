#import <UIKit/UIKit.h>
#import "WCTableViewNormalCellManager.h"

@interface WCPLSettingViewController : UIViewController

@property (nonatomic, strong) UITextField *placeholderTextField;  // 用于显示和修改占位符文本
@property (nonatomic, strong) UIButton *colorPickerButton;  // 用于选择占位符颜色

- (void)reloadTableData;  // 重新加载表格数据
- (void)addBasicSettingSection;  // 添加设置项

- (void)initTitle;  // 设置页面标题
- (void)onBack:(UIBarButtonItem *)item;  // 返回按钮处理

// 创建占位符文本和颜色设置项
- (WCTableViewNormalCellManager *)createPlaceholderTextCell;
- (WCTableViewNormalCellManager *)createPlaceholderColorCell;

@end
