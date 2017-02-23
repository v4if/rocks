<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<link rel="stylesheet" href="${base}/libs/editor.md/css/editormd.css" />
<body>

    <div class="aw-container-wrap">
        <div class="container">

            <form method="post" id="form-deploy">
                <input type="text" class="form-control" placeholder="话题" name="title"><br>
                <div id="test-editormd">
                    <textarea class="editormd-markdown-textarea" name="stone-markdown-doc"></textarea>
                </div>

                <button class="btn btn-primary pull-right" type="submit" id="btn-deploy">发起话题</button>
            </form>

        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
    <script src="${base}/libs/editor.md/editormd.min.js"></script>

    <script>
        $(function() {
            var testEditor = editormd("test-editormd", {
                width   : "100%",
                height  : 500,
                syncScrolling : "single",
                path    : "${base}/libs/editor.md/lib/",
                watch   : false,
                toolbarIcons: function () {
                    return editormd.toolbarModes["simple"]; // full, simple, mini
                }
            });

            $("#btn-deploy").click(function () {
                $.ajax({
                    url: "${base}/topic/post",
                    data: $("#form-deploy").serialize(),
                    method: "POST",
                    dataType: "json",
                    success: function (resp) {
                        if (resp) {
                            if (resp.ok) {
                                window.location = "${base}";
                            } else {
                                alert(resp.msg);
                            }
                        }
                    }
                });
                return false;
            });
        });
    </script>
</body>
</html>


