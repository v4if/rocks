<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<link rel="stylesheet" href="${base}/libs/editor.md/css/editormd.preview.min.css" />

<body>
    <%@ include file="/WEB-INF/jsp/_partial/header.jsp"%>

    <div class="aw-container-wrap">
        <div class="container">
            <div class="aw-content-wrap">

                <div class="aw-mod aw-question-detail" id="topic-explore"></div>

                <div class="aw-mod aw-question-comment">
                    <div class="mod-body aw-feed-list" id="comment-list"></div>

                    <% if (me == null) { %>
                        <!-- 回复编辑器 -->
                        <div class="aw-mod aw-replay-box question">
                            <a name="form-answer"></a>
                            <p align="center">要回复话题请先<a href="${base}/user/login/">登录</a>或<a href="${base}/user/register/">注册</a></p>
                        </div>
                        <!-- end 回复编辑器 -->
                    <% } else { %>
                        <div class="aw-explore-list">
                            <form id="form-reply">
                                <fieldset>
                                    <div class="form-group">
                                        <input name="content" type="text" class="form-control" placeholder="请输入回复内容">
                                    </div>
                                    <input name="toTopic" type="hidden" id="topic-id">
                                    <button type="submit" class="btn btn-primary pull-right" id="btn-reply">回复话题</button>
                                </fieldset>
                            </form>
                        </div>
                    <% } %>

                </div>

            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
    <!-- <script src="js/zepto.min.js"></script>
    <script>
        var jQuery = Zepto;  // 为了避免修改flowChart.js和sequence-diagram.js的源码，所以使用Zepto.js时想支持flowChart/sequenceDiagram就得加上这一句
    </script> -->
    <script src="${base}/libs/editor.md/lib/marked.min.js"></script>
    <script src="${base}/libs/editor.md/lib/prettify.min.js"></script>
    <script src="${base}/libs/editor.md/lib/raphael.min.js"></script>
    <script src="${base}/libs/editor.md/lib/underscore.min.js"></script>
    <script src="${base}/libs/editor.md/lib/sequence-diagram.min.js"></script>
    <script src="${base}/libs/editor.md/lib/flowchart.min.js"></script>
    <script src="${base}/libs/editor.md/lib/jquery.flowchart.min.js"></script>
    <script src="${base}/libs/editor.md/editormd.min.js"></script>

    <script type="text/javascript">
        function topicReload() {
            $.ajax({
                url : "${base}/topic/explore",
                data : {"id":${obj}},
                dataType : "json",
                method : "POST",
                success : function(data) {
                    if (data === null) {
                        return;
                    }

                    var nodeHtml =
                            ' <div class="mod-head">' +
                            ' 	<h1>' +
                                    data.title +
                            ' 	</h1>' +
                            ' </div>' +
                            ' <div class="mod-body">' +
                            '	<div id="test-editormd-view"> ' +
                            '	    <textarea style="display:none;" name="test-editormd-markdown-doc">'+data.content+'</textarea> ' +
                            '	</div> ' +
                            ' </div>' +
                            ' <div class="mod-footer">' +
                            ' 	<div class="meta">' +
                            ' 		<span class="text-color-999 pull-right"><a href="${base}/user/profile/others?name=' + data.userName + '">' + data.userName + "</a> . 发起于 . " + data.createTime + '</span>' +
                            ' 	</div>' +
                            ' </div>';

                    $("#topic-explore").html(nodeHtml);
                    $("#topic-id").val(data.id);

                    var testEditormdView = editormd.markdownToHTML("test-editormd-view", {
                        // markdown        : markdown ,//+ "\r\n" + $("#append-test").text(),
                        //htmlDecode      : true,       // 开启 HTML 标签解析，为了安全性，默认不开启
                        htmlDecode      : "style,script,iframe",  // you can filter tags decode
                        //toc             : false,
                        tocm            : true,    // Using [TOCM]
                        //tocContainer    : "#custom-toc-container", // 自定义 ToC 容器层
                        //gfm             : false,
                        //tocDropdown     : true,
                        // markdownSourceCode : true, // 是否保留 Markdown 源码，即是否删除保存源码的 Textarea 标签
                        emoji           : false,
                        taskList        : true,
                        tex             : false,  // 默认不解析
                        flowChart       : true,  // 默认不解析
                        sequenceDiagram : true,  // 默认不解析
                    });
                }
            });
        }

        function commentReload() {
            $.ajax({
                url : "${base}/comment/query",
                data : {"id":${obj}},
                dataType : "json",
                method : "POST",
                success : function(data) {
                    var commentHtml = "";
                    var replyUser ="";

                    if (data.length > 0) {
                        for (var i = 0; i < data.length; i++) {
                            var comment = data[i];

                            <% if (me != null) { %>
                                replyUser ='<a class="toggle-reply text-color-999" data-toggle="hide" data-user="' +comment.userName +'"> 回复用户</a>' ;
                            <% } %>

                            var rUser = "";
                            if (comment.replyToUser) {
                                rUser = "回复了用户 . " + comment.replyToUser;
                            } else {
                                rUser = "回复了话题";
                            }

                            var tmp =
                                '<div class="aw-item">' +
                                '    <div class="mod-head">' +
                                '        <a class="anchor"></a>' +
                                '        <!-- 用户头像 -->' +
                                '        <a class="aw-user-img aw-border-radius-5 pull-right" href="${base}/user/profile/others?name=' + comment.userName + '">' +
                                '            <img src="${base}/user/profile/avatar/others?name=' + comment.userName + '" alt="">' +
                                '        </a>' +
                                '        <!-- end 用户头像 -->' +
                                '        <div class="title">' +
                                '            <p>' +
                                '                <span class="text-color-999 pull-right">'+ comment.createTime +'</span>' +
                                '                <span class="text-color-999"><a href="${base}/user/profile/others?name=">'+ comment.userName +'</a> . '+ rUser +'</span>' +
                                '            </p>' +
                                '        </div>' +
                                '    </div>' +
                                '    <div class="mod-body clearfix">' +
                                '        <!-- 评论内容 -->' +
                                '        <div class="markitup-box">' +
                                             comment.content + replyUser +
                                '        </div>' +
                                '        <!-- end 评论内容 -->' +
                                '    </div>' +
                                '   ' +
                                '</div>';
                            commentHtml += tmp;
                        }
                    } else {
                        commentHtml = '<p align="center" class="text-color-999">没有回复内容</p>';
                    }

                    $("#comment-list").html(commentHtml);

                    $(".toggle-reply").click(function() {
                        if ($(this).attr("data-toggle") === "hide"){
                            $(".toggle-reply").html(" 回复用户");
                            $(".toggle-reply").attr("data-toggle", "hide");

                            $(this).attr("data-toggle", "show");

                            var tmp =
                                '	<form id="form-reply-user">' +
                                '	    <fieldset>' +
                                '	        <div class="form-group">' +
                                '               <input name="toTopic" type="hidden" value="'+ $("#topic-id").val() +'">' +
                                '               <input name="toUser" type="hidden" value="' + $(this).attr("data-user") + '">' +
                                '	            <input name="content" type="text" class="form-control" placeholder="请输入回复内容">' +
                                '	        </div>' +
                                '	        <button type="submit" class="btn btn-primary pull-right" id="btn-reply-user">回复用户</button>';
                                '	    </fieldset>' +
                                '	</form>';
                            $(this).html(tmp);

                            $("#btn-reply-user").click(function() {
                                $.ajax({
                                    url: "${base}/comment/post",
                                    data: $("#form-reply-user").serialize(),
                                    dataType: "json",
                                    method: "POST",
                                    success: function (data) {
                                        if (data.ok) {
                                            location.reload();
                                        } else {
                                            alert(data.msg);
                                        }
                                    }
                                });
                                return false;
                            });
                        }
                        return false;

                    });
                }
            });
        }


        $(function() {
            $("ul.nav>li:eq(1)").addClass("active");

            topicReload();

            commentReload();

            $("#btn-reply").click(function () {
                $.ajax({
                    url: "${base}/comment/post",
                    data: $("#form-reply").serialize(),
                    dataType: "json",
                    method: "POST",
                    success: function (data) {
                        if (data.ok) {
                            location.reload();
                        } else {
                            alert(data.msg);
                        }
                    }
                });
                return false;
            });
        });

    </script>
</body>
</html>