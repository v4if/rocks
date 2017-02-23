<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<body>
    <%@ include file="/WEB-INF/jsp/_partial/header.jsp"%>

    <div class="aw-container-wrap">
        <div class="container">
            <div class="aw-content-wrap">
                <div class="v-profile">
                    <img alt="用户头像" src="${base}/user/profile/avatar/others?name=${obj.userName}">
                    <div class="v-user">
                        <c:out value="${obj.userName}"></c:out><p />
                    </div>
                    <div class="clearfix v-dt">
                        ${obj.description}
                    </div>
                <div>
                <div class="v-nav-divider"></div>
                <ul class="v-dashboard">
                    <li><a href="${base}/user/profile/setting" class="btn-primary">个人设置</a></li>
                    <li><a href="${base}/topic/post" class="btn-success">发起话题</a></li>
                    <li><a href="${base}/file/upload" class="btn-warning">上传文件</a></li>
                </ul>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>

</body>
</html>