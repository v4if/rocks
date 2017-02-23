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

                <form action="${base}/file/upload" method="post" enctype="multipart/form-data" id="upload_form" class="form-inline">
                    <div class="form-group">
                        <label class="pull-left">选择上传文件：</label>
                        <input type="file" name="file" class="pull-left">
                        <input type="hidden" name="scope" id="file-group">
                    </div>
                    <button type="submit" id="upload_btn" class="form-control">上传</button>
                </form>

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
        </div>

    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
    <script>
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
                error: function () {
                },
                success: function (data) {
                    $("#walk-tree").html(walk(data));

                    $("li span.pickup").dblclick(function(){
                        $("#file-now").html($(this).html());
                        $("#file-group").val($(this).data("id"));
                    });
                }
            });
        }
        $(function () {
            $("ul.nav>li:eq(2)").addClass("active");
            fileGroupReload();
        });
    </script>

</body>
</html>