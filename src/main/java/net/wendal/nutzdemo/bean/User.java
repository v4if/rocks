package net.wendal.nutzdemo.bean;

import java.util.Date;

import org.nutz.dao.entity.annotation.*;

@Table("t_user")
public class User {

    @Id
    private int id;

    @Name
    private String name;

    @Column("passwd")
    @ColDefine(width = 128)
    private String password;

    @Column("salt")
    @ColDefine(width = 128)
    private String salt;

//    创建时间
    @Column("create_time")
    @Prev(els = @EL("now()"))
    private Date createTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
