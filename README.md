# Rocks 基于nutz的内部论坛 ![Language Java](https://img.shields.io/badge/language-java-blue.svg?style=flat-square)

基于[nutz](https://github.com/nutzam/nutz)框架开发的内部论坛系统，可以发起话题并讨论回复，上传文件，并做了相应的权限管理

## 项目使用

* 修改resources/custom/db.properties下mysql的用户名，密码
* 建立数据库create database rocks default character set utf8;
* 使用Maven compile构建项目，生成target
* 使用Jetty容器运行该项目

## 项目特性

* 登录注册管理
* 话题讨论、回复
* 用户消息通知
* 树形结构的文件管理
* 基于文件类型叶子节点粒度的权限管理

## 项目展示

![result](https://rawgit.com/v4if/rocks/master/2017-02-22-203743.png)

![result](https://rawgit.com/v4if/rocks/master/2017-02-22-203954.png)

![result](https://rawgit.com/v4if/rocks/master/2017-02-22-204102.png)
