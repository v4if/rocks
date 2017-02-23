<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<link rel="stylesheet" href="${base}/libs/mmtree/treestyles.css" type="text/css"/>
<script type="text/javascript" src="${base}/libs/mmtree/marktree.js"></script>
<body>
    <%@ include file="/WEB-INF/jsp/_partial/header.jsp"%>

    <div class="aw-container-wrap">
        <div class="container">
            <div class="aw-content-wrap v-nav">

                <div id="user-node"></div>
                <div id="file-group-node"></div>
                <div id="file-authority-node"></div>
                <div id="file-node"></div>

            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>

    <script>
        function userReload() {
            $.ajax({
                url: "${base}/user/query",
                success: function (data) {
                    var htmlNode =
                        ' <legend>用户</legend>' +
                        ' <table class="table table-striped table-bordered table-condensed"> ' +
                        '     <tr> ' +
                        '       <th>用户</th>' +
                        '       <th>创建时间</th>' +
                        '       <th>操作</th>' +
                        '     </tr>';
                    for (var i = 0; i < data.length; i++) {
                        var user = data[i];
                        var tmp =
                            '     <tr> ' +
                            '         <td class="v-pointer">' + user.name + '</td> ' +
                            '         <td>' + user.createTime + '</td> ' +
                            '         <td><a data-user="'+ user.name +'">删除</a></td> ' +
                            '     </tr> ';
                        htmlNode += tmp;
                    }
                    htmlNode += ' </table> ' +
                                '	<div class="v-box-otb"> ' +
                                '	<form class="form-inline" id="form-user-add">	' +
                                '	    <fieldset>	' +
                                '	        <div class="form-group">	' +
                                '	            <label>用户名：</label>	' +
                                '	            <input type="text" class="form-control" name="username">	' +
                                '	        </div>	' +
                                '	        <div class="form-group">	' +
                                '	            <label>密码：</label>	' +
                                '	            <input type="password" class="form-control" name="password">	' +
                                '	        </div>	' +
                                '	        <button type="submit" class="btn btn-default" id="btn-user-add">添加用户</button>	' +
                                '	    </fieldset>	' +
                                '	</form>	' +
                                '	</div> ' ;

                    $("#user-node").html(htmlNode);
                    $("#user-node .v-pointer").click(function(){
                        $(".out-user").html($(this).html());
                        $("input.hidden-user").val($(this).html());
                    });
                    $("#user-node a").click(function(){
                        $.ajax({
                            url: "${base}/user/delete",
                            method: "POST",
                            data : {"userName": $(this).data("user")},
                            dataType : "json",
                            success: function (data) {
                                if(data.ok) {
                                    location.reload();
                                } else {
                                    alert(data.msg);
                                }
                            }
                        });
                        return false;
                    });

                    $("#btn-user-add").click(function(){
                        $.ajax({
                            url: "${base}/user/add",
                            method: "POST",
                            data : $("#form-user-add").serialize(),
                            dataType : "json",
                            success: function (data) {
                                if(data.ok) {
                                    location.reload();
                                } else {
                                    alert(data.msg);
                                }
                            }
                        });
                        return false;
                    });
                }
            });
        }

        function walk(data) {
            var treeHtml = "<ul>";

            function hellCall(data) {
                var i, j;
                for (i = 0; i < data.length; i++) {
                    var fileGroup = data[i];
                    if (fileGroup.sub === null) {
                        treeHtml +=
                            '<li class="basic">' +
                            '   <span data-id="' + fileGroup.id + '" class="pickup leafnode">' + fileGroup.name + '</span>';


                        if (fileGroup.owners.length > 0) {
                            treeHtml +=
                            '   <span class="text-color-999">&nbsp;&nbsp;当前负责人：';
                            for (j = 0; j < fileGroup.owners.length; j++) {
                                treeHtml += fileGroup.owners[j].userName;
                                if (j != fileGroup.owners.length -1) {
                                    treeHtml += "、&nbsp;&nbsp;";
                                }
                            }
                        }

                        treeHtml +=
                            '   </span>' +
                            '</li>';
                    } else {
                        treeHtml +=
                            '<li class="col"> ' +
                            '   <span data-id="' + fileGroup.id + '" class="pickup">' + fileGroup.name + '</span> ';

                        treeHtml +=
                            '   </span>' +
                            '   <ul class="subexp">';
                        hellCall(fileGroup.sub);
                        treeHtml +=
                            '   </ul>' +
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
                url: "${base}/file/group/query/owner",
                error: function () {
                },
                success: function (data) {
                    var nodePre='<legend>文件组</legend>';
                    var nodeAppend=
                            '	<div class="v-box-otb"> ' +
                            '	<form class="form-inline" id="form-fgroup-add">	' +
                            '	    <fieldset>	' +
                            '	        <div class="form-group">	' +
                            '	            <label>父节点(单击节点选择)：</label>	' +
                            '	            <input type="hidden" class="form-control hidden-file" name="fileGroup">	' +
                            '	            <span class="text-color-999 out-file">文件组</span>	' +
                            '	        </div>	' +
                            '	        <div class="form-group">	' +
                            '	            <label>添加节点名：</label>	' +
                            '	            <input type="text" class="form-control" name="iName" placeholder="输入新添加的节点名">	' +
                            '	        </div>	' +
                            '	        <button type="submit" class="btn btn-default" id="btn-fgroup-add">添加文件组节点</button>	' +
                            '	    </fieldset>	' +
                            '	</form>	' +
                            '	</div> ' +
                            '	<div class="v-box-otb"> ' +
                            '	<form class="form-inline" id="form-fgroup-delete">	' +
                            '	    <fieldset>	' +
                            '	        <div class="form-group">	' +
                            '	            <label>删除节点(单击节点选择)：</label>	' +
                            '	            <input type="hidden" class="form-control hidden-file" name="fileGroup">	' +
                            '	            <span class="text-color-999 out-file">文件组</span>	' +
                            '	        </div>	' +
                            '	        <button type="submit" class="btn btn-default" id="btn-fgroup-delete">删除文件组节点</button>	' +
                            '	    </fieldset>	' +
                            '	</form>	' +
                            '	</div> ' +
                            '<div id="v-sub-node"></div>';
                    $("#file-group-node").html(nodePre + walk(data) + nodeAppend);

                    var authNode =
                            '   <legend>文件组权限</legend>' +
                            '	<div class="v-box-otb"> ' +
                            '	<form class="form-inline" id="form-grant-add">	' +
                            '	    <fieldset>	' +
                            '	        <div class="form-group">	' +
                            '	            <label>当前文件组(单击叶子节点选择)：</label>	' +
                            '	            <input type="hidden" class="form-control ua-hidden-file" name="scope">	' +
                            '	            <span class="text-color-999 ua-out-file">文件组</span>	' +
                            '	        </div>	' +
                            '	        <div class="form-group">	' +
                            '	            <label>当前用户(单击用户选择)：</label>	' +
                            '	            <input type="hidden" class="form-control" name="object" value="file">	' +
                            '	            <input type="hidden" class="form-control" name="action" value="ud">	' +
                            '	            <input type="hidden" class="form-control hidden-user" name="userName">	' +
                            '	            <span class="text-color-999 out-user">&nbsp;&nbsp;</span>	' +
                            '	        </div>	' +
                            '	        <button type="submit" class="btn btn-default" id="btn-grant-add">添加该文件组负责人</button>	' +
                            '	    </fieldset>	' +
                            '	</form>	' +
                            '	</div> ' +
                            '	<div class="v-box-otb"> ' +
                            '	<form class="form-inline" id="form-grant-delete">	' +
                            '	    <fieldset>	' +
                            '	        <div class="form-group">	' +
                            '	            <label>当前文件组(单击叶子节点选择)：</label>	' +
                            '	            <input type="hidden" class="form-control ua-hidden-file" name="scope">	' +
                            '	            <span class="text-color-999 ua-out-file">文件组</span>	' +
                            '	        </div>	' +
                            '	        <div class="form-group">	' +
                            '	            <label>当前用户(单击用户选择)：</label>	' +
                            '	            <input type="hidden" class="form-control" name="object" value="file">	' +
                            '	            <input type="hidden" class="form-control" name="action" value="ud">	' +
                            '	            <input type="hidden" class="form-control hidden-user" name="userName">	' +
                            '	            <span class="text-color-999 out-user">&nbsp;&nbsp;</span>	' +
                            '	        </div>	' +
                            '	        <button type="submit" class="btn btn-default" id="btn-grant-delete">删除该文件组负责人</button>	' +
                            '	    </fieldset>	' +
                            '	</form>	' +
                            '	</div> ';
                    $("#file-authority-node").html(authNode);

                    $("li span.pickup").click(function(){
                        $("span.out-file").html($(this).html());
                        $("input.hidden-file").val($(this).data("id"));

                        if ($(this).hasClass("leafnode")) {
                            $("span.ua-out-file").html($(this).html());
                            $("input.ua-hidden-file").val($(this).data("id"));
                            $("span.update-out-file").html($(this).html());
                            $("input.update-hidden-file").val($(this).data("id"));
                        }
                    });

                    $("li span.leafnode").dblclick(function() {
                        fileReload($(this).data("id"), $(this).html());
                    });

                    $("#btn-fgroup-add").click(function(){
                        $.ajax({
                            url: "${base}/file/group/add",
                            method: "POST",
                            data : $("#form-fgroup-add").serialize(),
                            dataType : "json",
                            error: function () {
                            },
                            success: function (data) {
                                if(data.ok) {
                                    location.reload();
                                } else {
                                    alert(data.msg);
                                }
                            }
                        });
                        return false;
                    });

                    $("#btn-fgroup-delete").click(function(){
                        $.ajax({
                            url: "${base}/file/group/delete",
                            method: "POST",
                            data : $("#form-fgroup-delete").serialize(),
                            dataType : "json",
                            error: function () {

                            },
                            success: function (data) {
                                if(data.ok) {
                                    location.reload();
                                } else {
                                    alert(data.msg);
                                }
                            }
                        });
                        return false;
                    });

                    $("#btn-grant-add").click(function(){
                        $.ajax({
                            url: "${base}/user/authority/add",
                            data : $("#form-grant-add").serialize(),
                            dataType : "json",
                            error: function () {

                            },
                            success: function (data) {
                                if(data.ok){
                                    location.reload();
                                } else {
                                    alert(data.msg);
                                }
                            }
                        });
                        return false;
                    });

                    $("#btn-grant-delete").click(function(){
                        $.ajax({
                            url: "${base}/user/authority/delete",
                            data : $("#form-grant-delete").serialize(),
                            dataType : "json",
                            error: function () {

                            },
                            success: function (data) {
                                if(data.ok){
                                    location.reload();
                                } else {
                                    alert(data.msg);
                                }
                            }
                        });
                        return false;
                    });

                    fileReload();
                }
            });
        }

        function fileReload(id, curFile) {
            $.ajax({
                url: "${base}/file/query/all",
                data : {"id":id},
                dataType : "json",
                error: function () {

                },
                success: function (data) {
                    var file = curFile?curFile:'文件组';
                    var htmlNode =
                        ' <legend>文件</legend>' +
                        '<p>当前文件位置(双击叶子节点选择)：<span class="text-color-999" id="file-now">'+ file +'</span></p>' +
                        ' <table class="table table-striped table-bordered table-condensed"> ' +
                        '     <tr> ' +
                        '       <th>文件</th>' +
                        '       <th>上传用户</th>' +
                        '       <th>上传时间</th>' +
                        '       <th>操作</th>' +
                        '     </tr>';
                    for (var i = 0; i < data.length; i++) {
                        var file = data[i];
                        var tmp =
                            '     <tr> ' +
                            '         <td class="v-pointer" data-id="'+file.id+'">' + file.rawName + '</td> ' +
                            '         <td>' + file.userName + '</td> ' +
                            '         <td>' + file.createTime + '</td> ' +
                            '         <td><a data-file="'+ file.fName +'">删除</a></td> ' +
                            '     </tr> ';
                        htmlNode += tmp;
                    }
                    htmlNode += ' </table> ' +
                                '	<div class="v-box-otb"> ' +
                                '	<form class="form-inline" id="form-file-update">	' +
                                '	    <fieldset>	' +
                                '	        <div class="form-group">	' +
                                '	            <label>当前文件(单击文件选择)：</label>	' +
                                '	            <input type="hidden" class="form-control cur-hidden-file" name="fileId">	' +
                                '	            <span class="text-color-999 cur-out-file">&nbsp;&nbsp;</span>	' +
                                '	        </div>	' +
                                '	        <div class="form-group">	' +
                                '	            <label>更新文件组(单击叶子节点选择)：</label>	' +
                                '	            <input type="hidden" class="form-control update-hidden-file" name="toGroupId">	' +
                                '	            <span class="text-color-999 update-out-file">文件组</span>	' +
                                '	        </div>	' +
                                '	        <button type="submit" class="btn btn-default" id="btn-file-update">更新文件组</button>	' +
                                '	    </fieldset>	' +
                                '	</form>	' +
                                '	</div> ' ;

                    $("#file-node").html(htmlNode);
                    $("#file-node a").click(function(){
                        $.ajax({
                            url: "${base}/file/delete",
                            method: "POST",
                            data : {"fileName": $(this).data("file")},
                            dataType : "json",
                            error: function () {
                            },
                            success: function (data) {
                                if(data.ok) {
                                    location.reload();
                                } else {
                                    alert(data.msg);
                                }
                            }
                        });
                        return false;
                    });

                    $("#file-node .v-pointer").click(function(){
                        $("span.cur-out-file").html($(this).html());
                        $("input.cur-hidden-file").val($(this).data("id"));
                    });

                    $("#btn-file-update").click(function(){
                        $.ajax({
                            url: "${base}/file/update",
                            method: "POST",
                            data : $("#form-file-update").serialize(),
                            dataType : "json",
                            success: function (data) {
                                if(data.ok) {
                                    location.reload();
                                } else {
                                    alert(data.msg);
                                }
                            }
                        });
                        return false;
                    });
                }
            });
        }

        $(function() {
            userReload();
            fileGroupReload();
        });
    </script>
</body>
</html>