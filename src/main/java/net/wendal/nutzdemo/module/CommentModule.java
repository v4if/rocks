package net.wendal.nutzdemo.module;

import net.wendal.nutzdemo.bean.Topic;
import net.wendal.nutzdemo.bean.Comment;
import net.wendal.nutzdemo.bean.Logger;
import net.wendal.nutzdemo.bean.User;
import net.wendal.nutzdemo.util.HtmlSoup;
import org.nutz.dao.Cnd;
import org.nutz.dao.Dao;
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
 * Created by root on 1/24/17.
 */
@Filters(@By(type= CheckSession.class, args={"me", "/user/login"}))
@At("/comment")
@Ok("json:{locked:'password|salt'}")
@IocBean
public class CommentModule {
    private static final Log log = Logs.get();
    @Inject
    private Dao dao;

    @Filters
    @At
    public Object query(@Param("id")int id) {
        return dao.query(Comment.class, Cnd.where("replyToTopic", "=", id).desc("createTime"));
    }

    @POST
    @At
    public NutMap post(@Attr(scope= Scope.SESSION, value="me")User user, @Param("toUser")String toUser,
                       @Param("toTopic")int toTopic, @Param("content")String content) {
        NutMap re = new NutMap("ok", false);
        if (Strings.isBlank(content)) {
            return re.setv("msg", "内容不能为空");
        }
        if (toTopic < 1) {
            return re.setv("msg", "话题不存在");
        }
        Topic topic = dao.fetch(Topic.class, toTopic);
        if (topic == null) {
            return re.setv("msg", "话题不存在");
        }

        Comment comment = new Comment();
        comment.setUserName(user.getName());
        comment.setReplyToUser(toUser);
        comment.setContent(HtmlSoup.escapeHtml(content));
        comment.setReplyToTopic(toTopic);
        dao.insert(comment);

        if (Strings.isBlank(toUser)) {
            Logger logger = new Logger();
            logger.setUserName(user.getName());
            logger.setAction("回复了话题");
            logger.setLogInfo(topic.getTitle());
            logger.setDingUser(topic.getUserName());
            logger.setTargetLink("/topic/explore?id=" + topic.getId());
            logger.setHasRead(false);
            dao.insert(logger);
        } else {
            Logger logger = new Logger();
            logger.setUserName(user.getName());
            logger.setAction("回复了用户 " + toUser);
            logger.setLogInfo(topic.getTitle());
            logger.setDingUser(toUser);
            logger.setTargetLink("/topic/explore?id=" + topic.getId());
            logger.setHasRead(false);
            dao.insert(logger);
        }

        return re.setv("ok", true);
    }
}
