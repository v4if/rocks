package net.wendal.nutzdemo.bean;

import org.nutz.dao.entity.annotation.Column;
import org.nutz.dao.entity.annotation.Id;
import org.nutz.dao.entity.annotation.Name;
import org.nutz.dao.entity.annotation.Table;
import org.nutz.json.JsonField;

/**
 * Created by root on 1/17/17.
 */
@Table("t_user_profile")
public class UserProfile {
//    关联的用户id
    @Name()
    private String userName;

//    用户邮箱
    @Column
    private String email;

//    邮箱是否验证
    @Column("email_checked")
    private boolean emailChecked;

//    头像的byte数据
    @Column
    @JsonField(ignore = true)
    private byte[] avatar;

//    自我介绍
    @Column("dt")
    private String description;

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isEmailChecked() {
        return emailChecked;
    }

    public void setEmailChecked(boolean emailChecked) {
        this.emailChecked = emailChecked;
    }

    public byte[] getAvatar() {
        return avatar;
    }

    public void setAvatar(byte[] avatar) {
        this.avatar = avatar;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
