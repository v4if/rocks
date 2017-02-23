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

                    <div class="aw-common-list" id="logger-list">
                    </div>

                    <div class="page-control">
                        <ul class="pagination pull-center" id="pagination">
                        </ul>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
    <script type="text/javascript">
        var pageNumber = 1;
        function pagerRender(start, number, count) {
            var pagerHtml = "";
            var end = start + 4 > count ? count : start + 4;
            if (start > 1) {
                pagerHtml += '<li><a>&lt;&lt;</a></li><li><a>&lt;</a></li>';
            }
            for (var i = start; i <= end; i++) {
                var tmp = "";
                if (i == number) {
                    tmp = '<li class="active"><a>' + i + '</a></li>';
                } else {
                    tmp = '<li><a>' + i + '</a></li>';
                }
                pagerHtml += tmp;
            }
            if (end < count) {
                pagerHtml += '<li><a>&gt;</a></li><li><a>&gt;&gt;</a></li>';
            }
            $("#pagination").html(pagerHtml);

            $("#pagination a").click(function () {
                var pagerClick = $(this).html();
                if (pagerClick == "&lt;&lt;") {
                    pagerRender(1, number, count);
                } else if (pagerClick == "&lt;") {
                    pagerRender(start > 5 ? start - 5 : 1, number, count);
                } else if (pagerClick == "&gt;") {
                    pagerRender(start + 5 > count ? count : start + 5, number, count);
                } else if (pagerClick == "&gt;&gt;") {
                    pagerRender(count > 4 ? count - 4 : 1, number, count);
                } else {
                    pageNumber = $(this).html();
                    loggerReload();
                }
                return false;
            });
        }


        function loggerReload() {
            $.ajax({
                url : "${base}/logger/query",
                data : {"pageNumber":pageNumber},
                dataType : "json",
                success : function(data) {
                    var loggerHtml = "";
                    for (var i = 0;i < data.list.length;i++) {
                        var logger = data.list[i];

                        var tmp =
                                '<div class="aw-item clearfix">' +
                                '       <div class="pull-left">' +
                                '           <a href="${base}/user/profile/others?name=' + logger.userName + '">' +
                                '               <img class="aw-user-img aw-border-radius-5" src="${base}/user/profile/avatar/others?name=' + logger.userName + '">' +
                                '           </a>' +
                                '       </div>' +
                                '       <h4>' +
                                '            <a href="${base}/user/profile/others?name=' + logger.userName + '">'+ logger.userName +'</a> .' +
                                '            <span class="text-color-999">'+ logger.action +'</span> .' +
                                '            <a href="${base}' + logger.targetLink + '">' + logger.logInfo + '</a>' +
                                '       </h4>' +
                                '       <span class="text-color-999">'+ logger.createTime +'</span>' +
                                '</div>';
                        loggerHtml += tmp;
                    }
                    $("#logger-list").html(loggerHtml);

                    var pagerStart = data.pager.pageNumber > 2 ? data.pager.pageNumber - 2 : 1;
                    pagerRender(pagerStart, data.pager.pageNumber, data.pager.pageCount);
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