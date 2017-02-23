<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<body>
    <div class="aw-container-wrap">
        <div class="container">
            <form id="form-register">
                <fieldset>
                    <legend>用户注册</legend>
                    <div class="form-group">
                        <label>注册账户</label>
                        <input name="username" type="text" class="form-control" placeholder="请输入你的用户名">
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input name="password" type="password" class="form-control" placeholder="请输入你的密码">
                    </div>

                    <button type="submit" class="btn btn-warning" id="btn-register">注册</button>
                    <a href="${base}/user/login" class="btn btn-primary pull-right">已经有账号，登录？</a>
                </fieldset>
            </form>
        </div>
    </div>

	<%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
	<script type="text/javascript">
		$(function() {
			$("#btn-register").click(function() {
				$.ajax({
					url : "${base}/user/register",
					data : $("#form-register").serialize(),
					method : "POST",
					dataType : "json",
					success : function(resp) {
						if (resp) {
							if (resp.ok) {
								window.location = "${base}";
							} else {
								//layer.alert("注册失败: " + resp.msg);
								alert("注册失败：" + resp.msg);
							}
						}
					}
				});
				return false;
			});

		});
	</script>


</body>