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

                <%
                    if (session.getAttribute("msg") != null) {
                        String msg = session.getAttribute("msg").toString();
                %>
                    <div class="alert alert-danger v-nav">
                        <button type="button" class="close" data-dismiss="alert">×</button>
                        <strong><%=msg%></strong>
                    </div>
                <%
                        session.removeAttribute("msg");
                    }
                %>
                <div>
                    <form action="${base}/user/profile/avatar" method="post"
                        enctype="multipart/form-data">
                        <label class="pull-left v-item">头像文件：</label> <input type="file" name="file" class="pull-left v-item">
                        <button type="submit" class="v-item">更新头像</button>
                    </form>

                </div>

                <div class="v-clear-float">
                    <form action="#" id="user_profile" method="post">
                        <label class="pull-left v-item">自我介绍：</label><input name="description" value="${obj.description}" class="v-item">
                    </form>
                    <button type="button" id="user_profile_btn" class="v-item">更新</button>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
    <script type="text/javascript">
        var base = '${base}';
        $.fn.serializeObject = function() {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function() {
                if (o[this.name] !== undefined) {
                    if (!o[this.name].push) {
                        o[this.name] = [ o[this.name] ];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        };
        $(function() {
            $("#user_profile_btn").click(function() {
                //alert(JSON.stringify($("#user_profile").serializeObject()));
                $.ajax({
                    url : base + "/user/profile/update",
                    type : "POST",
                    data : JSON.stringify($("#user_profile").serializeObject()),
                    success : function() {
                        location.reload();
                    }
                });
            });
        });
    </script>
</body>
</html>