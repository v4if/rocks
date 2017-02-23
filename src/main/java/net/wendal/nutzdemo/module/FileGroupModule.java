package net.wendal.nutzdemo.module;

import net.wendal.nutzdemo.bean.UpFile;
import net.wendal.nutzdemo.bean.UserAuthority;
import net.wendal.nutzdemo.bean.FileGroup;
import net.wendal.nutzdemo.bean.User;
import net.wendal.nutzdemo.util.HtmlSoup;
import org.nutz.dao.*;
import org.nutz.dao.Chain;
import org.nutz.dao.util.Daos;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.Strings;
import org.nutz.lang.util.NutMap;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.annotation.*;
import org.nutz.mvc.filter.CheckSession;

import java.util.*;

/**
 * Created by root on 1/19/17.
 */
@Filters(@By(type= CheckSession.class, args={"me", "/user/login"}))
@Ok("json:{locked:'password|salt'}")
@At("/file/group")
@IocBean
public class FileGroupModule {

    private static final Log log = Logs.get();

    @Inject
    private Dao dao;

//    遍历fileGroup，以json形式返回
    @Filters
    @At
    public Object query() {
        return displayChildren(-1);
    }

    private Object displayChildren(int parent) {
        List<FileGroup> list = dao.query(FileGroup.class, Cnd.where("parent_id", "=", parent));

        if (list.isEmpty()) {
            return null;
        }

        List<NutMap> nutList = new ArrayList<NutMap>();
        for (FileGroup item : list) {
            NutMap nutTmp = new NutMap();
            nutTmp.setv("id", item.getId());
            nutTmp.setv("name", item.getName());
            nutTmp.setv("sub", displayChildren(item.getId()));
            nutList.add(nutTmp);
        }

        return nutList;
    }

//    只有root才能对文件组操作
    private boolean matchAuthority(int userId) {
        if (userId == 1) {
            return true;
        }

        return false;
    }

//    删除文件组拥有者权限
    private void delOwnersUa(int fileGroupId) {
        List<UserAuthority> uaList = dao.query(UserAuthority.class, Cnd.where("scope", "like", "%|"+fileGroupId+"|%"));

        for (UserAuthority old : uaList) {
            String newScope = old.getScope().replace(String.valueOf(fileGroupId) + "|", "");
            if (newScope.trim().equals("|")) {
                dao.delete(UserAuthority.class, old.getId());
            } else {
                dao.update(UserAuthority.class, Chain.make("scope", newScope), Cnd.where("id", "=", old.getId()));
            }
        }
    }

//    文件组变动时删除对应的拥有者权限
    private void delUaChildren(int parentId) {
        delOwnersUa(parentId);

        List<FileGroup> fList = dao.query(FileGroup.class, Cnd.where("parentId", "=", parentId));
        for (FileGroup f : fList) {
            delOwnersUa(f.getId());
        }
    }

    @POST
    @At
    public NutMap add(@Attr("me") User user, @Param("fileGroup")int parentId, @Param("iName")String nodeName) {     //两个点号是对象属性设置
        NutMap re = new NutMap("ok", false);

        if (!matchAuthority(user.getId())) {
            return re.setv("msg", "用户没有权限");
        }

        if (parentId < 1 || dao.fetch(FileGroup.class, Cnd.where("id", "=", parentId)) == null)
            return re.setv("msg", "父节点不存在");

        if (Strings.isBlank(nodeName))
            return re.setv("msg", "新添加文件组节点不能为空");

//        添加前为叶子节点，删除该文件组的拥有者权限
        boolean isLeaf = false;
        if (dao.fetch(FileGroup.class, Cnd.where("parentId", "=", parentId)) == null) {
            delOwnersUa(parentId);
            isLeaf = true;
        }

        FileGroup fileGroup = new FileGroup();
        fileGroup.setParentId(parentId);
        fileGroup.setName(HtmlSoup.escapeHtml(nodeName));
        dao.insert(fileGroup);

//        将该叶子节点下的文件转移到新添加的节点下
        if (isLeaf) {
            dao.update(UpFile.class, Chain.make("groupId", fileGroup.getId()),
                    Cnd.where("groupId", "=", parentId));
        }

        return re.setv("ok", true);
    }

    private void deleteChildren(int parent) {
        List<FileGroup> list = dao.query(FileGroup.class, Cnd.where("parent_id", "=", parent));

        if (list.isEmpty()) return;

        for (FileGroup item : list) {
            deleteChildren(item.getId());
            dao.delete(FileGroup.class, item.getId());
        }
    }

    @POST
    @At
    public NutMap delete(@Attr("me") User user, @Param("fileGroup")int parentId) {     //两个点号是对象属性设置
        NutMap re = new NutMap("ok", false);

        if (!matchAuthority(user.getId())) {
            return re.setv("msg", "用户没有权限");
        }

        if (parentId < 1 || dao.delete(FileGroup.class, parentId) != 1)
            return re.setv("msg", "父节点不存在");

        delUaChildren(parentId);
        deleteChildren(parentId);

        return re.setv("ok", true);
    }

    //    遍历fileGroup，以json形式返回
//    带有属性owners，负责人
    @At("/query/owner")
    public Object queryAndOwner() {
        return displayChildrenAndOwner(-1);
    }

    private List<NutMap> displayChildrenAndOwner(int parent) {
        List<FileGroup> list = dao.query(FileGroup.class, Cnd.where("parent_id", "=", parent));

        if (list.isEmpty()) {
            return null;
        }

        List<NutMap> nutList = new ArrayList<NutMap>();
        for (FileGroup item : list) {
            NutMap nutTmp = new NutMap();
            nutTmp.setv("id", item.getId());
            nutTmp.setv("name", item.getName());

            List<UserAuthority> ua = Daos.ext(dao, FieldFilter.create(UserAuthority.class, "userName")).query(UserAuthority.class,
                    Cnd.where("object","=", "file").and("action", "=", "ud").and("scope", "like", "%|"+item.getId()+"|%"));

            List<NutMap> listTmp = displayChildrenAndOwner(item.getId());
            if (listTmp == null) {
                nutTmp.setv("owners", ua);
            } else {
                nutTmp.setv("owners", null);
            }
            nutTmp.setv("sub", listTmp);
            nutList.add(nutTmp);
        }

        return nutList;
    }
}
