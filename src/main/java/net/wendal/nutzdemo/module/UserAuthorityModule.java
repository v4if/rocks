package net.wendal.nutzdemo.module;

import net.wendal.nutzdemo.bean.FileGroup;
import net.wendal.nutzdemo.bean.User;
import net.wendal.nutzdemo.bean.UserAuthority;
import org.nutz.dao.Cnd;
import org.nutz.dao.Dao;
import org.nutz.dao.Chain;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.Strings;
import org.nutz.lang.util.NutMap;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.annotation.*;
import org.nutz.mvc.filter.CheckSession;

/**
 * Created by root on 1/24/17.
 */
@Filters(@By(type = CheckSession.class, args = {"me", "/user/login"}))
@Ok("json:{locked:'password|salt'}")
@At("/user/authority")
@IocBean
public class UserAuthorityModule {
    private static final Log log = Logs.get();

    @Inject
    private Dao dao;

    private boolean containsKey(String[] array, String key) {
        for (String s : array) {
            if (s.equals(key)) {
                return true;
            }
        }

        return false;
    }

    private boolean matchAuthority(int userId) {
        if (userId == 1) {
            return true;
        }

        return false;
    }

    @At
    public NutMap add(@Attr("me") User user, @Param("userName")String userName, @Param("object")String object,
                      @Param("action")String action, @Param("scope")int scope) {
        NutMap re = new NutMap("ok", false);

        if (!matchAuthority(user.getId())) {
            return re.setv("msg", "用户没有权限");
        }

        if (Strings.isBlank(userName) || Strings.isBlank(object) || Strings.isBlank(action) || scope < 1) {
            return re.setv("msg", "用户名等不能为空");
        }

        if (dao.fetch(FileGroup.class, Cnd.where("parentId", "=", scope)) != null) {
            return re.setv("msg", "文件组必须为叶子节点");
        }

        Cnd cnd = Cnd.where("userName", "=", userName).and("object", "=", object).and("action", "=", action);
        UserAuthority old = dao.fetch(UserAuthority.class, cnd);
        if (old == null) {
            UserAuthority userAuthority = new UserAuthority();
            userAuthority.setUserName(userName);
            userAuthority.setObject(object);
            userAuthority.setAction(action);
            userAuthority.setScope("|" + String.valueOf(scope) + "|");
            dao.insert(userAuthority);
        } else {
            if (!old.getScope().contains("|" + scope + "|")) {
                dao.update(UserAuthority.class, Chain.make("scope", old.getScope() +
                        String.valueOf(scope) + "|"), cnd);
            } else {
                return re.setv("msg", "用户存在该权限");
            }
        }

        return re.setv("ok", true);
    }

    @At
    public NutMap delete(@Attr("me") User user, @Param("userName")String userName, @Param("object")String object,
                      @Param("action")String action, @Param("scope")int scope) {
        NutMap re = new NutMap("ok", false);

        if (!matchAuthority(user.getId())) {
            return re.setv("msg", "用户没有权限");
        }

        if (Strings.isBlank(userName) || Strings.isBlank(object) || Strings.isBlank(action) || scope < 1) {
            return re.setv("msg", "用户名等不能为空");
        }

        if (dao.fetch(FileGroup.class, Cnd.where("parentId", "=", scope)) != null) {
            return re.setv("msg", "文件组必须为叶子节点");
        }

        Cnd cnd = Cnd.where("userName", "=", userName).and("object", "=", object).and("action", "=", action);
        UserAuthority old = dao.fetch(UserAuthority.class, cnd);
        if (old == null) {
            return re.setv("msg", "用户没有该权限");
        } else {
            if (old.getScope().contains("|" + scope + "|")) {
                String newScope = old.getScope().replace(scope + "|", "");
                if (newScope.trim().equals("|")) {
                    dao.delete(UserAuthority.class, old.getId());
                } else {
                    dao.update(UserAuthority.class, Chain.make("scope", newScope), cnd);
                }
            } else {
                return re.setv("msg", "用户没有该对象权限");
            }
        }

        return re.setv("ok", true);
    }

}
