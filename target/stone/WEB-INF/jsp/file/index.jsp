<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<link rel="stylesheet" href="${base}/libs/mmtree/treestyles.css" type="text/css"/>
<script type="text/javascript" src="${base}/libs/mmtree/marktree.js"></script>
<body>
    <%@ include file="/WEB-INF/jsp/_partial/header.jsp"%>

    <div id="base" class="basetext">
        <noscript>
            <p style="border: solid #ff0000; padding: 1em;text-align:center">
                <b>
                    Nodes cannot be expanded if JavaScript is disabled.<br/>Please enable JavaScript.
                </b>
            </p>
        </noscript>

        <div class="pull-right">
            <a href="#" onclick="expandAll(document.getElementById('base'))">展开</a>
            - <a href="#" onclick="collapseAll(document.getElementById('base'))">合并</a>
        </div>

        <div id="walk-tree"></div>

        <div class="v-nav">
            <p>当前文件位置(双击叶子节点选择)：<span class="text-color-999" id="file-now">文件组</span></p>
        </div>

        <div class="aw-explore-list">
            <div class="aw-common-list" id="file-list"></div>

            <div class="page-control">
                <ul class="pagination pull-center" id="pagination">
                </ul>
            </div>
        </div>

    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
    <script>
        var pageNumber = 1;
        function pagerRender(start, number, count) {
            var pagerHtml = "";
            var end = start + 4 > count ? count : start + 4;
            if (start > 1) {
                pagerHtml += '<li><a href="">&lt;&lt;</a></li><li><a href="">&lt;</a></li>';
            }
            for (var i = start; i <= end; i++) {
                var tmp = "";
                if (i == number) {
                    tmp = '<li class="active"><a href="">' + i + '</a></li>';
                } else {
                    tmp = '<li><a href="">' + i + '</a></li>';
                }
                pagerHtml += tmp;
            }
            if (end < count) {
                pagerHtml += '<li><a href="">&gt;</a></li><li><a href="">&gt;&gt;</a></li>';
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
                    fileReload();
                }
                return false;
            });
        }


        function fileReload(id) {
            $.ajax({
                url : "${base}/file/query",
                data : {"pageNumber":pageNumber, "id":id},
                dataType : "json",
                success : function(data) {
                    var fileHtml = "";
                    for (var i = 0;i < data.list.length;i++) {
                        var file = data.list[i];

                        var tmp =       '<div class="aw-item clearfix">' +
                                        '        <div class="pull-left"><a href="${base}/user/profile/others?name=' + file.userName + '"><img class="aw-user-img aw-border-radius-5" src="${base}/user/profile/avatar/others?name=' + file.userName + '"></a></div>' +
                                        '        <h4>' +
                                        '            <a href="${base}/user/profile/others?name=' + file.userName + '">'+ file.userName +'</a> .' +
                                        '            <span class="text-color-999">上传了文件</span> .' +
                                        '            <a href="${base}/file/download?file=' + file.fName + '">' + file.rawName + '</a>' +
                                        '        </h4>' +
                                        '        <span class="text-color-999">'+ file.createTime +'</span>' +
                                        '</div>';
                        fileHtml += tmp;
                    }
                    $("#file-list").html(fileHtml);

                    var pagerStart = data.pager.pageNumber > 2 ? data.pager.pageNumber - 2 : 1;
                    pagerRender(pagerStart, data.pager.pageNumber, data.pager.pageCount);
                }
            });
        }


        function walk(data) {
            var treeHtml = "<ul>";
            function hellCall(data) {
                for (var i = 0; i < data.length; i++) {
                    var fileGroup = data[i];
                    if (fileGroup.sub === null) {
                        treeHtml +=
                            '<li class="basic">' +
                            '   <span data-id="' + fileGroup.id + '" class="pickup">' + fileGroup.name + '</span>' +
                            '</li>';
                    } else {
                        treeHtml +=
                            '<li class="col"> ' +
                            '   <span data-id="' + fileGroup.id + '">' + fileGroup.name + '</span> ' +
                            '   <ul class="subexp">';
                        hellCall(fileGroup.sub);
                        treeHtml +=
                            '  </ul>' +
                            '</li>';
                    }
                }
            }
            hellCall(data);
            treeHtml += "</ul>";
            return treeHtml;
        }


        function fileGroupReload() {
            $.ajax({
                url: "${base}/file/group/query",
                success: function (data) {
                    $("#walk-tree").html(walk(data));

                    $("li span.pickup").dblclick(function(){
                        $("#file-now").html($(this).html());
                        pageNumber = 1;
                        fileReload($(this).data("id"));
                    });
                }
            });
        }


        $(function () {
            $("ul.nav>li:eq(2)").addClass("active");
            fileGroupReload();
            fileReload();
        });
    </script>

</body>
</html>