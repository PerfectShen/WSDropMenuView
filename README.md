# WSDropMenuView
类似美团的多级选择列表 － 简单易用 
(史上最简洁的 三级列表  ，并且很容易改造成两级和一级或者四级,实现代码不超过550行);
（来了帮忙点个 赞 star  －－ 好人一生平安）



[![预览图]](http://www.cnblogs.com/Seeulater/)
[预览图]:https://github.com/PerfectShen/WSDropMenuView/blob/master/dropMenu.gif "欢迎私信我哦"
[我的博客](http://www.cnblogs.com/Seeulater/ "欢迎私信我哦")


 [how to use?](http://www.cnblogs.com/Seeulater/ "欢迎私信我哦")
 
  
初始化对象
   
``` OC
WSDropMenuView *dropMenu = [[WSDropMenuView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 40)];
dropMenu.dataSource = self;
dropMenu.delegate  =self;
[self.view addSubview:dropMenu];  

```

  实现代理方法 (简单易用 ， 不繁琐)
```OC

- (NSInteger)dropMenuView:(WSDropMenuView *)dropMenuView numberWithIndexPath:(WSIndexPath *)indexPath; //dataSource

- (NSString *)dropMenuView:(WSDropMenuView *)dropMenuView titleWithIndexPath:(WSIndexPath *)indexPath //dataSource

- (void)dropMenuView:(WSDropMenuView *)dropMenuView didSelectWithIndexPath:(WSIndexPath *)indexPath //delegate
```

 
 
