package net.wendal.nutzdemo.bean;

import org.nutz.dao.entity.annotation.*;

import java.util.Date;

/**
 * Created by root on 1/17/17.
 */
@Table("t_comment")
public class Comment {
    @Id
    private int id;

    //    关联的用户
    @Column("me")
    private String userName;

//    回复的用户
    @Column("reply_to_user")
    private String replyToUser;

    @Column("reply_to_topic")
    private int replyToTopic;

//    评论内容
    @Column("content")
    private String content;

//    评论时间
    @Column("create_time")
    @Prev(els = @EL("now()"))
    private Date createTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getReplyToUser() {
        return replyToUser;
    }

    public void setReplyToUser(String replyToUser) {
        this.replyToUser = replyToUser;
    }

    public int getReplyToTopic() {
        return replyToTopic;
    }

    public void setReplyToTopic(int replyToTopic) {
        this.replyToTopic = replyToTopic;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
