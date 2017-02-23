<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="aw-footer-wrap">
    <div class="aw-footer">
        Copyright © 2017<span class="hidden-xs"> All Rights Reserved</span>
    </div>
</div>
<script type="text/javascript" src="${base}/static/js/jquery.min.js"></script>
<script type="text/javascript" src="${base}/static/js/bootstrap.min.js"></script>
<!--<script type="text/javascript" src="https://cdn.staticfile.org/layer/2.3/layer.js"></script>-->

<% if (me != null) { %>
    <script>
        $(function() {
            $.ajax({
                url : "${base}/user/ding",
                method: "POST",
                error : function() {
                },
                success : function(data) {
                    if(data.ok){
                        if(data.msg > 0) {
                            $("#ding-info").html(data.msg);
                        }
                    }
                }
            });
        });
    </script>
<% } %>
