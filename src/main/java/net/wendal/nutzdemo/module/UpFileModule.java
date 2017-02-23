package net.wendal.nutzdemo.module;

import net.wendal.nutzdemo.bean.Logger;
import net.wendal.nutzdemo.bean.UpFile;
import net.wendal.nutzdemo.bean.User;
import net.wendal.nutzdemo.bean.UserAuthority;
import net.wendal.nutzdemo.util.HtmlSoup;
import org.nutz.dao.*;
import org.nutz.dao.Chain;
import org.nutz.dao.pager.Pager;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.Files;
import org.nutz.lang.Strings;
import org.nutz.lang.util.NutMap;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.Mvcs;
import org.nutz.mvc.Scope;
import org.nutz.mvc.annotation.*;
import org.nutz.mvc.filter.CheckSession;
import org.nutz.mvc.impl.AdaptorErrorContext;
import org.nutz.mvc.upload.TempFile;
import org.nutz.mvc.upload.UploadAdaptor;

import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.SQLException;
import java.util.UUID;

/**
 * Created by root on 1/17/17.
 */
@Filters(@By(type= CheckSession.class, args={"me", "/user/login"}))
@Ok("json:{locked:'password|salt'}")
@At("/file")
@IocBean
public class UpFileModule {
    private static final String path = "WEB-INF/upload/file/";
    private static final Log log = Logs.get();

    @Inject
    private Dao dao;

//    分页查询
    @Filters
    @At
    public Object query(@Param("..")Pager pager, @Param("id")int fileGroup) {
        pager.setPageSize(8);

        Condition cnd = fileGroup < 1 ? Cnd.orderBy().desc("createTime") :
                Cnd.where("groupId", "=", fileGroup).desc("createTime");
        QueryResult qr = new QueryResult();
        qr.setList(dao.query(UpFile.class, cnd, pager));
        pager.setRecordCount(dao.count(UpFile.class, cnd));
        qr.setPager(pager);
        return qr; //默认分页是第1页,每页20条
    }

    @Filters
    @At("/query/all")
    public Object queryAll(@Param("id")int fileGroup) {
        Condition cnd = fileGroup < 1 ? Cnd.orderBy().desc("createTime") :
                Cnd.where("groupId", "=", fileGroup).desc("createTime");
        return dao.query(UpFile.class, cnd);
    }

//    首屏
    @Filters
    @At("/")
    @Ok("jsp:jsp.file.index")
    public void indexPage() {}

    @GET
    @At("/upload")
    @Ok("jsp:jsp.file.upload")
    public void uploadPage() {}

    @Filters
    @Ok("raw")
    @At()
    @GET
    public Object download(@Param("file")String fName) throws SQLException {
        NutMap re = new NutMap("ok", false);
        if (Strings.isBlank(fName))
            return re.setv("msg", "文件不能是空");

        UpFile file = dao.fetch(UpFile.class, Cnd.where("fName", "=", fName));
        if (file == null) {
            return re.setv("msg", "文件不存在");
        }

        File f = new File(Mvcs.getServletContext().getRealPath(path + file.getfName()));
        if (!f.exists()) {
            return re.setv("msg", "文件不存在");
        }

        try {
            Mvcs.getResp().setHeader("Content-Disposition", "attachment; filename=" +
                    java.net.URLEncoder.encode(file.getRawName(), "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            Mvcs.getResp().setHeader("Content-Disposition", "attachment; filename=" + fName);
        }

        return new File(Mvcs.getServletContext().getRealPath(path + fName));
    }

//    权限验证
    private boolean matchAuthority(User me, String object, String action, String scope) {
        if (me.getId() == 1)
            return true;

        Cnd cnd = Cnd.where("userName", "=", me.getName()).and("object", "=", object).and("action", "=", action);
        UserAuthority ua = dao.fetch(UserAuthority.class, cnd);

        if (ua != null && ua.getScope().contains("|" + scope + "|")) {
            return true;
        }

        return false;
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

    @AdaptBy(type=UploadAdaptor.class, args={"${app.root}/WEB-INF/upload/tmp", "8192", "utf-8", "10"})
    @POST
    @Ok(">>:/file/upload")
    @At()
    public void upload(@Param("file")TempFile tf, @Param("scope")int fileGroupId,
                       @Attr(scope=Scope.SESSION, value="me")User me, AdaptorErrorContext err) {

        HttpSession session = Mvcs.getHttpSession(false);
        if (fileGroupId < 1) {
            session.setAttribute("msg", "文件组必须为叶子节点");
            deleteTmpFile(tf);
            return;
        }

        if (!matchAuthority(me, "file", "ud", String.valueOf(fileGroupId))) {
            deleteTmpFile(tf);
            session.setAttribute("msg", "用户没有权限");
            return;
        }

        String msg = null;
        if (err != null && err.getAdaptorErr() != null) {
            msg = "上传失败";
        } else if (tf == null) {
            msg = "空文件";
        } else {
            File uf = tf.getFile();
            String uuid = UUID.randomUUID().toString().replaceAll("-", "") + "." + Files.getSuffixName(uf).toLowerCase();
            log.debug(Mvcs.getServletContext().getRealPath("WEB-INF/upload/file/") + uuid);
            uf.renameTo(new File(Mvcs.getServletContext().getRealPath("WEB-INF/upload/file") + "/" + uuid));


            UpFile upFile = new UpFile();
            upFile.setUserName(me.getName());
            upFile.setRawName(HtmlSoup.escapeHtml(tf.getSubmittedFileName()));
            upFile.setfName(uuid);
            upFile.setGroupId(fileGroupId);
            dao.insert(upFile);

            Logger sysLog = new Logger();
            sysLog.setUserName(me.getName());
            sysLog.setAction("上传了文件");
            sysLog.setLogInfo(HtmlSoup.escapeHtml(tf.getSubmittedFileName()));
            sysLog.setTargetLink("/file/download?file=" + uuid);
            dao.insert(sysLog);
        }

        if (msg != null) {
            session.setAttribute("msg", msg);
            deleteTmpFile(tf);
        } else {
            session.setAttribute("msg", "上传成功");
        }
    }

    @POST
    @At
    public NutMap delete(@Attr(scope=Scope.SESSION, value="me")User me,
                         @Param("fileName")String fileName) {
        NutMap re = new NutMap("ok", false);

        if (Strings.isBlank(fileName)) {
            return re.setv("msg", "文件名为空");
        }

        if (!matchAuthority(me, "file", "ud", fileName)) {
            return re.setv("msg", "用户没有权限");
        }

        UpFile upFile = dao.fetch(UpFile.class, Cnd.where("fName", "=", fileName));
        if (upFile == null) {
            return re.setv("msg", "文件不存在");
        }

        File file = new File(Mvcs.getServletContext().getRealPath(path + fileName));
        if (file.exists()) {
            file.delete();
        }

        dao.clear(UpFile.class, Cnd.where("fName", "=", fileName));
//        dao.clear(Logger.class, Cnd.where("action", "=", "上传了文件").and("logInfo", "=", upFile.getRawName()));
        return re.setv("ok", true);
    }

//    更新文件所在的文件组
    @POST
    @At
    public NutMap update(@Attr(scope=Scope.SESSION, value="me")User me,
                         @Param("fileId")int fileId, @Param("toGroupId")int toGroupId) {
        NutMap re = new NutMap("ok", false);

        if (me.getId() != 1) {
            return re.setv("msg", "用户没有权限");
        }

        if (fileId < 1 || toGroupId < 1) {
            return re.setv("msg", "文件、文件组不存在");
        }

        dao.update(UpFile.class, Chain.make("groupId", toGroupId), Cnd.where("id", "=", fileId));
        return re.setv("ok", true);
    }
}
