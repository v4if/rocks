<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="aw-top-menu-wrap">
    <div class="container">
        <!-- <span class="pull-left v-logo">v4if</span> -->
        <div class="aw-top-nav">
            <ul class="nav navbar-nav">
                <li><a href="${base}"><i class="icon iconfont icon-topic"></i> 发现</a></li>
                <li><a href="${base}/topic"><i class="icon iconfont icon-article"></i> 话题</a></li>
                <li><a href="${base}/file"><i class="icon iconfont icon-iconul"></i> 文件</a></li>
            </ul>
        </div>
        <div class="aw-user-nav">
            <% if (me == null) { %>
                <span>
                    <a class="login btn btn-normal btn-primary" href="${base}/user/login/">登录</a>
                </span>
            <% } else { %>
                <div>
                    <a href="${base}/user/ding"><span class="badge badge-important" id="ding-info"></span></a>
                    <a href="${base}/user/profile"><img alt="用户头像" src="${base}/user/profile/avatar"></a>
                    <a class="btn btn-normal btn-danger" href="${base}/user/logout/">注销</a>
                </div>
            <% } %>
        </div>
    </div>
</div>