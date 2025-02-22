#import "WCPLSettingViewController.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface WCPLSettingViewController () <UIColorPickerViewControllerDelegate>
@end

@implementation WCPLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle];  // 设置标题
    [self reloadTableData];  // 加载表格数据
}

- (void)initTitle {
    self.title = @"一包小薯条";  // 设置页面标题
    
    // 设置导航栏标题样式
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]}];
    
    // 设置返回按钮
    self.navigationItem.leftBarButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithImageName:@"ui-resource_back" target:self action:@selector(onBack:) style:0 accessibility:nil];
}

- (void)onBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadTableData {
    [self.tableViewMgr clearAllSection];  // 清空所有表格数据
    
    // 仅添加占位符文本和占位符颜色设置项
    [self addBasicSettingSection];  // 添加基本设置部分
}

- (void)addBasicSettingSection {
    WCTableViewSectionManager *section = [objc_getClass("WCTableViewSectionManager") sectionInfoHeader:@"设置"];
    
    // 添加占位符文本设置项
    WCTableViewNormalCellManager *textCell = [self createPlaceholderTextCell];
    [section addCell:textCell];
    
    // 添加自定义占位符颜色设置项
    WCTableViewNormalCellManager *colorCell = [self createPlaceholderColorCell];
    [section addCell:colorCell];
    
    [self.tableViewMgr addSection:section];
}

// 创建占位符文本设置项的单元格
- (WCTableViewNormalCellManager *)createPlaceholderTextCell {
    return [objc_getClass("WCTableViewNormalCellManager") normalCellForSel:@selector(editPlaceholderText:) 
                                                                   target:self 
                                                                   title:@"占位符文本" 
                                                                  detail:self.placeholderTextField.placeholder];
}

// 编辑占位符文本的回调方法
- (void)editPlaceholderText:(id)sender {
    self.placeholderTextField.text = @"新的占位符文本";
    // 保存到NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:self.placeholderTextField.text forKey:kCustomPlaceholderText];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 创建自定义占位符颜色设置项的单元格
- (WCTableViewNormalCellManager *)createPlaceholderColorCell {
    return [objc_getClass("WCTableViewNormalCellManager") normalCellForSel:@selector(selectColor:) 
                                                                   target:self 
                                                                   title:@"选择占位符颜色" 
                                                                  detail:@"点击选择"];
}

// 选择颜色的回调方法
- (void)selectColor:(UIButton *)sender {
    // 实现颜色选择器
    UIColorPickerViewController *colorPicker = [[UIColorPickerViewController alloc] init];
    colorPicker.delegate = self;
    [self presentViewController:colorPicker animated:YES completion:nil];
}

// 颜色选择回调方法
- (void)colorPickerViewController:(UIColorPickerViewController *)viewController didSelectColor:(UIColor *)color {
    // 转换UIColor为十六进制
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    NSString *hexColor = [NSString stringWithFormat:@"#%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
    
    // 保存自定义颜色
    [[NSUserDefaults standardUserDefaults] setObject:hexColor forKey:kCustomPlaceholderColor];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
