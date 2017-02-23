package net.wendal.nutzdemo.module;

import net.wendal.nutzdemo.bean.Topic;
import net.wendal.nutzdemo.bean.User;
import net.wendal.nutzdemo.util.HtmlSoup;
import net.wendal.nutzdemo.bean.Logger;
import org.nutz.dao.Cnd;
import org.nutz.dao.Dao;
import org.nutz.dao.QueryResult;
import org.nutz.dao.pager.Pager;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.Strings;
import org.nutz.lang.util.NutMap;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.Scope;
import org.nutz.mvc.annotation.*;
import org.nutz.mvc.filter.CheckSession;

/**
 * Created by root on 1/17/17.
 */

@At("/topic")
@Ok("json:{locked:'password|salt'}")
@IocBean
public class TopicModule {
    private static final Log log = Logs.get();
    @Inject
    private Dao dao;

//    话题页查询
    @At
    public Object query(@Param("..")Pager pager) {
        pager.setPageSize(8);

        QueryResult qr = new QueryResult();
        qr.setList(dao.query(Topic.class, Cnd.orderBy().desc("createTime"), pager));
        pager.setRecordCount(dao.count(Topic.class, null));
        qr.setPager(pager);
        return qr; //默认分页是第1页,每页20条
    }

//    话题首屏
    @At("/")
    @Ok("jsp:jsp.topic.index")
    public void indexPage() {}

//    Markdown view
    @GET
    @At("/explore")
    @Ok("jsp:jsp.topic.explore")
    public int explorePage(@Param("id")int id) {
        return id;
    }

    @POST
    @At
    public Topic explore(@Param("id")int id) {
        return dao.fetch(Topic.class, id);
    }

    @Filters(@By(type = CheckSession.class, args = {"me", "/user/login"}))
    @At("/post")
    @Ok("jsp:jsp.topic.post")
    public void postPage() {}

    @Filters(@By(type = CheckSession.class, args = {"me", "/user/login"}))
    @POST
    @At
    public NutMap post(@Attr(scope=Scope.SESSION, value="me")User user,
                       @Param("title")String title, @Param("stone-markdown-doc")String content) {
//        content-html-code 富文本内容，保存的Html源码
//        content-markdown-doc Markdown源码
        NutMap re = new NutMap("ok", false);
        if (Strings.isBlank(title) || Strings.isBlank(title)) {
            return re.setv("msg", "话题或Markdown不能为空");
        }

        Topic iNode = new Topic();
        iNode.setTitle(HtmlSoup.escapeHtml(title));
        iNode.setContent(HtmlSoup.escapeHtml(content));
        iNode.setUserName(user.getName());
        dao.insert(iNode);

        Logger iNodeLogger = new Logger();
        iNodeLogger.setUserName(user.getName());
        iNodeLogger.setAction("发起了话题");
        iNodeLogger.setLogInfo(iNode.getTitle());
        iNodeLogger.setTargetLink("/topic/explore?id=" + iNode.getId());
        dao.insert(iNodeLogger);

        return re.setv("ok", true);
    }
}
