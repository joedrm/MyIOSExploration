
#import "UIView+Find.h"

@implementation UIView (Find)

- (UIView *)findSubViewWithClass:(Class)clazz;
{
    for (UIView * subView in self.subviews)
    {
        if ([subView isKindOfClass:clazz])
        {
            return subView;
        }
    }
    
    return nil;
}

- (NSArray *)findAllSubViewsWithClass:(Class)clazz
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (UIView * subView in self.subviews)
    {
        if ([subView isKindOfClass:clazz])
        {
            [array addObject:subView];
        }
    }
    
    return array;
}

- (UIView *)findSuperViewWithClass:(Class)clazz;
{
    if (self == nil)
    {
        return nil;
    }
    else if (self.superview == nil)
    {
        return nil;
    }
    else if ([self.superview isKindOfClass:clazz])
    {
        return self.superview;
    }
    else
    {
        return [self.superview findSuperViewWithClass:clazz];
    }
}

- (UIView *)findFirstResponder
{
    if (([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]])
        && (self.isFirstResponder))
    {
        return self;
    }
    
    for (UIView *v in self.subviews)
    {
        UIView *fv = [v findFirstResponder];
        if (fv)
        {
            return fv;
        }
    }
    
    return nil;
}

- (UIViewController *)findViewController;
{
    UIResponder *responder = self.nextResponder;
    do
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    }
    while (responder);
    
    return nil;
}

- (UITableView *)findSuperTableView
{
    if ([self isKindOfClass:[UITableView class]]) {
        return (UITableView *)self;
    }
    if (self.superview) {
        UITableView * tableView= [self.superview findSuperTableView];
        if (tableView != nil) {
            return tableView;
        }
    }
    return nil;
}

- (UITableViewCell*)findSuperTableViewCell
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)self;
    }
    if (self.superview) {
        UITableViewCell  * tableViewCell = [self.superview findSuperTableViewCell];
        if (tableViewCell != nil) {
            return tableViewCell;
        }
    }
    return nil;
}


- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (NSArray *)allSubviews
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    [array addObjectsFromArray:self.subviews];
    
    for (UIView *view in self.subviews)
    {
        [array addObjectsFromArray:[view allSubviews]];
    }
    
    return array;
}

@end
