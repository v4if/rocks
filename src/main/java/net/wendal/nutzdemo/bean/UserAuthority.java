package net.wendal.nutzdemo.bean;

import org.nutz.dao.entity.annotation.Column;
import org.nutz.dao.entity.annotation.Id;
import org.nutz.dao.entity.annotation.Table;

/**
 * Created by root on 1/19/17.
 */
@Table("t_user_authority")
public class UserAuthority {
    @Id
    private int id;

//    关联的用户
    @Column("user_name")
    private String userName;

//    授权的实体对象，如file、user
    @Column
    private String object;

//    授权的动作，如curd、ud(upload|delete)
    @Column
    private String action;

//    授权的作用范围，如all、file_group_id
    @Column
    private String scope;

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

    public String getObject() {
        return object;
    }

    public void setObject(String object) {
        this.object = object;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }
}
