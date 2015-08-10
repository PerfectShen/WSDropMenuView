# WSDropMenuView
类似美团的多级选择列表 － 简单易用



[![预览图]](http://www.cnblogs.com/Seeulater/)
[预览图]:https://github.com/PerfectShen/WSDropMenuView/blob/master/dropMenu.gif "点击有惊喜"
[我的博客](http://www.cnblogs.com/Seeulater/ "点击有惊喜")


 [how to use?](http://www.cnblogs.com/Seeulater/)
 
  
  初始化对象
   
``` OC
WSDropMenuView *dropMenu = [[WSDropMenuView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 40)];
dropMenu.dataSource = self;
dropMenu.delegate  =self;
[self.view addSubview:dropMenu];  

```

  实现代理方法
```OC

- (NSInteger)dropMenuView:(WSDropMenuView *)dropMenuView numberWithIndexPath:(WSIndexPath *)indexPath; //dataSource

- (NSString *)dropMenuView:(WSDropMenuView *)dropMenuView titleWithIndexPath:(WSIndexPath *)indexPath //dataSource

- (void)dropMenuView:(WSDropMenuView *)dropMenuView didSelectWithIndexPath:(WSIndexPath *)indexPath //delegate
```

 
 
