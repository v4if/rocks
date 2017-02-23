package net.wendal.nutzdemo.bean;

import org.nutz.dao.entity.annotation.*;
import org.w3c.dom.Text;

import java.util.Date;

/**
 * Created by root on 1/17/17.
 */
@Table("t_topic")
public class Topic {
    @Id
    private int id;

//    关联的用户
    @Column("me")
    private String userName;

//    话题
    @Column("title")
    private String title;

//    话题内容
    @Column("content")
    @ColDefine(customType = "TEXT", type = ColType.VARCHAR)
    private String content;

//    话题创建时间
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
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
