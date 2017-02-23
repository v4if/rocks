package net.wendal.nutzdemo.module;


import net.wendal.nutzdemo.bean.User;
import net.wendal.nutzdemo.bean.UserAuthority;
import net.wendal.nutzdemo.util.HtmlSoup;
import net.wendal.nutzdemo.bean.UserProfile;
import net.wendal.nutzdemo.bean.Logger;
import org.nutz.dao.*;
import org.nutz.dao.Chain;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.Lang;
import org.nutz.lang.Strings;
import org.nutz.lang.random.R;
import org.nutz.lang.util.NutMap;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.annotation.*;
import org.nutz.mvc.filter.CheckSession;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

//检查当前session是否带me这个属性
@Filters(@By(type = CheckSession.class, args = {"me", "/user/login"}))
@Ok("json:{locked:'password|salt'}")
@At("/user")
@IocBean
public class UserModule {

    private static final Log log = Logs.get();

//    注入一个同名的ioc对象
    @Inject
    protected Dao dao;

    @Filters    //覆盖UserModule类的@Filter设置，因为登陆可不能要求是个已经登陆的session
    @GET
    @At({"/login"})
    @Ok("jsp:jsp.user.login")
    public void loginPage() {}

    @Filters    //覆盖UserModule类的@Filter设置，因为登陆可不能要求是个已经登陆的session
    @GET
    @At({"/register"})
    @Ok("jsp:jsp.user.register")
    public void registerPage() {}

    @At("/dashboard")
    @Ok("jsp:jsp.user.dashboard")
    public void dashboardPage() {}

    @Filters
    @POST
    @At
    public NutMap login(String username, String password, HttpSession session) {
        NutMap re = new NutMap("ok", false);
        if (session.getAttribute("me") != null) {
            return re.setv("msg", "已经登录");
        }

        if (Strings.isBlank(username) || Strings.isBlank(password)) {
            return re.setv("msg", "用户名或密码不能为空");
        }
        User user = dao.fetch(User.class, username);
        if (user == null) {
            return re.setv("msg", "没有该用户");
        }
        String tmp = Lang.digest("SHA-256", user.getSalt() + password);
        if (!tmp.equals(user.getPassword())) {
            return re.setv("msg", "密码错误");
        }
        session.setAttribute("me", user);
        return re.setv("ok", true);
    }

    @Filters
    @POST
    @At
    public NutMap register(@Param("username")String username, @Param("password")String password, HttpSession session) {
        NutMap re = new NutMap("ok", false);
        if (Strings.isBlank(username))
            return re.setv("msg", "名字不能是空");
        if (Strings.isBlank(password))
            return re.setv("msg", "密码不能是空");
        if (dao.fetch(User.class, username) != null) {
            return re.setv("msg", "存在该用户");
        }

        User user = new User();
        user.setName(HtmlSoup.escapeHtml(username));
        user.setSalt(R.UU32());
        user.setPassword(Lang.digest("SHA-256", user.getSalt() + password));
        dao.insert(user);
        session.setAttribute("me", user);
        return re.setv("ok", true);
    }

    @Filters
    @At
    @Ok(">>:/")   //这个方法完成之后就跳转页面
    public void logout(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null)
            session.invalidate();
    }

    @At("/ding")
    @Ok("jsp:jsp.user.ding")
    public void dingPage(@Attr("me") User user) {
    }

    @At("/ding")
    @POST
    public NutMap ding(@Attr("me") User user) {
        NutMap re = new NutMap("ok", false);

        re.setv("msg", dao.count(Logger.class, Cnd.where("dingUser", "=", user.getName()).and("hasRead", "=", "false")));
        return re.setv("ok", true);
    }

    @At("/ding/query")
    public Object dingQuery(@Attr("me") User user) {
        Cnd cnd = Cnd.where("dingUser", "=", user.getName()).and("hasRead", "=", "false");
        QueryResult qr = new QueryResult();
        qr.setList(dao.query(Logger.class, cnd));

        dao.update(Logger.class, Chain.make("hasRead", true),
                Cnd.where("dingUser", "=", user.getName()).and("hasRead", "=", "false"));
        return qr; //默认分页是第1页,每页20条
    }

    @At
    public Object query() {
        Cnd cnd = Cnd.where("name", "!=", "root");
        return dao.query(User.class, cnd);
    }

    private boolean matchAuthority(int userId) {
        if (userId == 1) {
            return true;
        }

        return false;
    }

    @POST
    @At
    public NutMap add(@Attr("me") User user, @Param("username")String username, @Param("password")String password) {
        NutMap re = new NutMap("ok", false);

        if (!matchAuthority(user.getId())) {
            return re.setv("msg", "用户没有权限");
        }

        if (Strings.isBlank(username))
            return re.setv("msg", "名字不能是空");
        if (Strings.isBlank(password))
            return re.setv("msg", "密码不能是空");
        if (dao.fetch(User.class, username) != null) {
            return re.setv("msg", "存在该用户");
        }

        User addUser = new User();
        addUser.setName(HtmlSoup.escapeHtml(username));
        addUser.setSalt(R.UU32());
        addUser.setPassword(Lang.digest("SHA-256", addUser.getSalt() + password));
        dao.insert(addUser);

        return re.setv("ok", true);
    }

    @POST
    @At
    public NutMap delete(@Attr("me") User user, @Param("userName")String userName) {
        NutMap re = new NutMap("ok", false);

        if (!matchAuthority(user.getId())) {
            return re.setv("msg", "用户没有权限");
        }

        if (Strings.isBlank(userName)) {
            return re.setv("msg", "用户名不能是空");
        }

        User del = dao.fetch(User.class, userName);
        if (del.getId() == 1){
            return new NutMap("msg", "不能删除root");
        }

        if (dao.delete(User.class, userName) == 1) {
            dao.clear(UserProfile.class, Cnd.where("userName", "=", userName));
            dao.clear(UserAuthority.class, Cnd.where("userName", "=", userName));
            return re.setv("ok", true);
        }

        return re;
    }
}
