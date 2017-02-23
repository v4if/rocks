<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<body>
    <%@ include file="/WEB-INF/jsp/_partial/header.jsp"%>

    <div class="aw-container-wrap">
        <div class="container">
            <div class="aw-content-wrap">
                <div class="aw-explore-list">
                    <div class="aw-common-list">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
    <script type="text/javascript">

        function loggerReload() {
            $.ajax({
                url : "${base}/user/ding/query",
                error : function() {
                },
                success : function(data) {
                    var loggerHtml = "";
                    for (var i = 0;i < data.list.length;i++) {
                        var logger = data.list[i];

                        var tmp =       '<div class="aw-item clearfix">' +
                                        '        <div class="pull-left"><a href="${base}/user/profile/others?name=' + logger.userName + '"><img class="aw-user-img aw-border-radius-5" src="${base}/user/profile/avatar/others?name=' + logger.userName + '"></a></div>' +
                                        '        <h4>' +
                                        '            <a href="${base}/user/profile/others?name=' + logger.userName + '">'+ logger.userName +'</a> .' +
                                        '            <span class="text-color-999">'+ logger.action +'</span> .' +
                                        '            <a href="${base}' + logger.targetLink + '">' + logger.logInfo + '</a>' +
                                        '        </h4>' +
                                        '        <span class="text-color-999">'+ logger.createTime +'</span>' +
                                        '</div>';
                        loggerHtml += tmp;
                    }
                    $(".aw-common-list").html(loggerHtml);
                }
            });
        }
        $(function() {
            $("ul.nav>li:eq(0)").addClass("active");
            loggerReload();
        });
    </script>
</body>
</html>