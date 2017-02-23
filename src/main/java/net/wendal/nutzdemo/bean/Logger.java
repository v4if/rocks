package net.wendal.nutzdemo.bean;

import org.nutz.dao.entity.annotation.*;

import java.util.Date;

/**
 * Created by root on 1/19/17.
 */
@Table("t_logger")
public class Logger {
    @Id
    private int id;

    //    关联的用户
    @Column("me")
    private String userName;

//    跳转链接
    @Column("target_link")
    private String targetLink;

//    日志动作
    @Column()
    private String action;

//    日志具体操作
    @Column("log_info")
    private String logInfo;

//    需要通知的用户
    @Column("ding_user")
    private String dingUser;

//    通知是否已读
    @Column("has_read")
    private boolean hasRead;

//    日志创建时间
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

    public String getTargetLink() {
        return targetLink;
    }

    public void setTargetLink(String targetLink) {
        this.targetLink = targetLink;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getLogInfo() {
        return logInfo;
    }

    public void setLogInfo(String logInfo) {
        this.logInfo = logInfo;
    }

    public String getDingUser() {
        return dingUser;
    }

    public void setDingUser(String dingUser) {
        this.dingUser = dingUser;
    }

    public boolean isHasRead() {
        return hasRead;
    }

    public void setHasRead(boolean hasRead) {
        this.hasRead = hasRead;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
