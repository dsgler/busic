# busic

一个 B站 音乐播放器

[说明]

- 登录
  用手机版B站扫码确认登录后回到应用点击 `确认已登录`。
  `获取登录状态` 用于检查登录是否过期。
  不登陆也可以使用，不过可能无法访问某些视频。

- 收藏夹
  在网页打开收藏夹，链接类似

```
https://space.bilibili.com/用户mid/favlist?fid=收藏夹ID&ftype=create&spm_id_from=333.1007.0.0
```

请填入收藏夹ID

- 视频合辑
  网页打开合辑

```
https://space.bilibili.com/用户mid/lists/合辑ID?type=season
```

目前合辑和收藏夹只能同步，不能单独添加和删除，请在B站上编辑
