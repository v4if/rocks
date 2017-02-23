<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<body>
    <%@ include file="/WEB-INF/jsp/_partial/header.jsp"%>

    <c:if test="${obj!=null}">
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
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${obj==null}">
        <div class="aw-container-wrap">
            <div class="container">
                <div class="aw-content-wrap">
                    <p align="center" style="margin:30px" class="text-color-999">查无此人</p>
                </div>
            </div>
        </div>
    </c:if>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
</body>
</html>