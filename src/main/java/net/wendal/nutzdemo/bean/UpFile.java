package net.wendal.nutzdemo.bean;

import org.nutz.dao.entity.annotation.*;

import java.util.Date;

/**
 * Created by root on 1/17/17.
 */
@Table("t_file")
public class UpFile {
    @Id
    private int id;

    //    关联的用户
    @Column("me")
    private String userName;

//关联的文件组
    @Column("group_id")
    private int groupId;

//    上传提交的源文件名
    @Column("raw_name")
    private String rawName;

//    临时存储文件名
    @Column("f_name")
    private String fName;

//    文件上传时间
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

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getRawName() {
        return rawName;
    }

    public void setRawName(String rawName) {
        this.rawName = rawName;
    }

    public String getfName() {
        return fName;
    }

    public void setfName(String fName) {
        this.fName = fName;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
