<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/_partial/head.jsp"%>
<body>
    <div class="aw-container-wrap">
        <div class="container">
            <form id="form-login">
                <fieldset>
                    <legend>用户登录</legend>
                    <div class="form-group">
                        <label>登录账户</label>
                        <input name="username" type="text" class="form-control" placeholder="请输入你的用户名">
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input name="password" type="password" class="form-control" placeholder="请输入你的密码">
                    </div>

                    <button type="submit" class="btn btn-primary" id="btn-login">登录</button>
                    <a href="${base}/user/register" class="btn btn-warning pull-right">还没有账号，注册？</a>
                </fieldset>
            </form>
        </div>
    </div>

	<%@ include file="/WEB-INF/jsp/_partial/footer.jsp"%>
	<script type="text/javascript">
		$(function() {
			$("#btn-login").click(function() {
				$.ajax({
					url : "${base}/user/login",
					data : $("#form-login").serialize(),
					method : "POST",
					dataType : "json",
					success : function(resp) {
						if (resp) {
							if (resp.ok) {
								//layer.alert("登录成功,即将跳转");
								window.location = "${base}";
							} else {
								//layer.alert("登录失败: " + resp.msg);
								alert("登录失败："+resp.msg);
							}
						}
					}
				});
				return false;
			});

		});
	</script>
</body>