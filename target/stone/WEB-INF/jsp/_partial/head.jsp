<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "net.wendal.nutzdemo.bean.User"%>
<head>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
    <meta name="renderer" content="webkit" />
    <title>石头</title>
    <meta name="keywords" content="blog,bbs" />
    <meta name="description" content="blog,bbs" />

    <link href="${base}/static/img/favicon.ico" rel="shortcut icon" type="image/x-icon"/>

    <link rel="stylesheet" type="text/css" href="${base}/static/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="${base}/static/fonts/iconfont.css" />

    <link href="${base}/static/css/common.css" rel="stylesheet" type="text/css" />
</head>


<%
    User me = null;
    if (session.getAttribute("me") != null){
        me = (User)session.getAttribute("me");
    }
%>