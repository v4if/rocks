package net.wendal.nutzdemo.module;

import net.wendal.nutzdemo.util.HtmlSoup;
import net.wendal.nutzdemo.bean.User;
import net.wendal.nutzdemo.bean.UserProfile;
import org.nutz.dao.Dao;
import org.nutz.dao.DaoException;
import org.nutz.dao.FieldFilter;
import org.nutz.dao.util.Daos;
import org.nutz.img.Images;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.Strings;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.Mvcs;
import org.nutz.mvc.Scope;
import org.nutz.mvc.adaptor.JsonAdaptor;
import org.nutz.mvc.annotation.*;
import org.nutz.mvc.filter.CheckSession;
import org.nutz.mvc.impl.AdaptorErrorContext;
import org.nutz.mvc.upload.TempFile;
import org.nutz.mvc.upload.UploadAdaptor;

import javax.servlet.http.HttpServletRequest;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.sql.SQLException;

/**
 * Created by root on 1/17/17.
 */
@Filters(@By(type= CheckSession.class, args={"me", "/user/login"}))
@At("user/profile")
@Ok("json:{locked:'password|salt'}")
@IocBean
public class UserProfileModule {
    private static final Log log = Logs.get();

    @Inject
    protected Dao dao;

    private UserProfile get(String userName) {
        UserProfile profile = Daos.ext(dao, FieldFilter.locked(UserProfile.class, "avatar")).fetch(UserProfile.class, userName);
        if (profile == null) {
            profile = new UserProfile();
            profile.setUserName(userName);
            dao.insert(profile);
        }
        return profile;
    }

    @At("/")
    @GET
    @Ok("jsp:jsp.user.profile")
    public UserProfile index(@Attr(scope=Scope.SESSION, value="me")User user) {
        return get(user.getName());
    }

    @Filters
    @At
    @GET
    @Ok("jsp:jsp.user.others")
    public UserProfile others(@Param("name")String name) {
        return Daos.ext(dao, FieldFilter.locked(UserProfile.class, "avatar")).fetch(UserProfile.class, name);
    }

    @At("/setting")
    @Ok("jsp:jsp.user.setting")
    public UserProfile setting(@Attr(scope=Scope.SESSION, value="me")User user) {
        return get(user.getName());
    }

    @At
    @AdaptBy(type=JsonAdaptor.class)
    @Ok("void")
    public void update(@Param("..")UserProfile profile, @Attr(scope=Scope.SESSION, value="me")User user) {
        String userName = user.getName();
        if (profile == null)
            return;
        profile.setUserName(userName);//修正userId,防止恶意修改其他用户的信息
        profile.setAvatar(null); // 不准通过这个方法更新
        UserProfile old = get(userName);
        // 检查email相关的更新
        if (old.getEmail() == null) {
            // 老的邮箱为null,所以新的肯定是未check的状态
            profile.setEmailChecked(false);
        } else {
            if (profile.getEmail() == null) {
                profile.setEmail(old.getEmail());
                profile.setEmailChecked(old.isEmailChecked());
            } else if (!profile.getEmail().equals(old.getEmail())) {
                // 设置新邮箱,果断设置为未检查状态
                profile.setEmailChecked(false);
            } else {
                profile.setEmailChecked(old.isEmailChecked());
            }
        }
//        XSS
        profile.setDescription(HtmlSoup.escapeHtml(profile.getDescription()));
        Daos.ext(dao, FieldFilter.create(UserProfile.class, null, "avatar", true)).update(profile);
    }

    //    删除上传的临时文件
    private void deleteTmpFile(TempFile tf) {
        if (tf != null) {
            File file = new File(Mvcs.getServletContext().getRealPath("WEB-INF/upload/tmp/00/00/00/00/00/00/00" + "/" +
                    tf.getFile().getName()));
            if (file.exists()) {
                file.delete();
            }
        }
    }
//    @AdaptBy(type=UploadAdaptor.class, args={"${app.root}/WEB-INF/tmp/user_avatar", "8192", "utf-8", "20000", "102400"})
    @AdaptBy(type=UploadAdaptor.class, args={"${app.root}/WEB-INF/upload/tmp", "8192", "utf-8", "2"})
    @POST
    @Ok(">>:/user/profile/setting")
    @At("/avatar")
    public void uploadAvatar(@Param("file")TempFile tf,
                             @Attr(scope=Scope.SESSION, value="me")User user,
                             AdaptorErrorContext err) {
        String msg = null;
        if (err != null && err.getAdaptorErr() != null) {
            msg = "文件大小不符合规定";
        } else if (tf == null) {
            msg = "空文件";
        } else {
            UserProfile profile = get(user.getName());
            try {
                BufferedImage image = Images.read(tf.getFile());
                image = Images.zoomScale(image, 128, 128, Color.WHITE);
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                Images.writeJpeg(image, out, 0.8f);
                profile.setAvatar(out.toByteArray());
                dao.update(profile, "^avatar$");
            } catch(DaoException e) {
                msg = "系统错误";
            } catch (Throwable e) {
                msg = "图片格式错误";
            } finally {
                deleteTmpFile(tf);
            }
        }

        if (msg != null) {
            Mvcs.getHttpSession().setAttribute("msg", msg);
        }

        deleteTmpFile(tf);
    }

    @Ok("raw:jpg")
    @At("/avatar")
    @GET
    public Object readAvatar(@Attr(scope=Scope.SESSION, value="me")User user, HttpServletRequest req) throws SQLException {
        UserProfile profile = Daos.ext(dao, FieldFilter.create(UserProfile.class, "^avatar$")).fetch(UserProfile.class, user.getName());
        if (profile == null || profile.getAvatar() == null) {
            return new File(req.getServletContext().getRealPath("/WEB-INF/upload/avatar/none.jpg"));
        }
        return profile.getAvatar();
    }

    @Filters
    @Ok("raw:jpg")
    @At("/avatar/others")
    @GET
    public Object readOthersAvatar(@Param("name")String name, HttpServletRequest req) throws SQLException {
        if (Strings.isBlank(name)) {
            return null;
        }
        UserProfile profile = Daos.ext(dao, FieldFilter.create(UserProfile.class, "^avatar$")).fetch(UserProfile.class, name);
        if (profile == null || profile.getAvatar() == null) {
            return new File(req.getServletContext().getRealPath("/WEB-INF/upload/avatar/none.jpg"));
        }
        return profile.getAvatar();
    }
}
