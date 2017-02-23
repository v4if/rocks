package net.wendal.nutzdemo;

import net.wendal.nutzdemo.bean.FileGroup;
import net.wendal.nutzdemo.bean.Logger;
import net.wendal.nutzdemo.bean.Topic;
import net.wendal.nutzdemo.bean.User;
import org.nutz.dao.Dao;
import org.nutz.dao.util.Daos;
import org.nutz.ioc.Ioc;
import org.nutz.lang.Lang;
import org.nutz.lang.random.R;
import org.nutz.mvc.NutConfig;
import org.nutz.mvc.Setup;

public class MainSetup implements Setup {

    public void init(NutConfig nc) {
        Ioc ioc = nc.getIoc();
        Dao dao = ioc.get(Dao.class);
        Daos.createTablesInPackage(dao, getClass(), false);

        if (0 == dao.count(User.class)) {
            User user = new User();
            user.setName("root");
            user.setSalt(R.UU32());
            user.setPassword(Lang.digest("SHA-256", user.getSalt() + "123456"));
            dao.insert(user);
        }

        if (0 == dao.count(Topic.class)) {
            Topic topic = new Topic();
            topic.setUserName("root");
            topic.setTitle("话题圈");
            topic.setContent("可以在这里进行话题讨论");
            dao.insert(topic);

            Logger logger = new Logger();
            logger.setUserName("root");
            logger.setAction("发起了话题");
            logger.setLogInfo("话题圈");
            logger.setTargetLink("/topic/explore?id=1");
            logger.setHasRead(false);
            dao.insert(logger);
        }

        if (0 == dao.count(FileGroup.class)) {
            FileGroup fileGroup = new FileGroup();
            fileGroup.setName("文件组");
            fileGroup.setParentId(-1);
            dao.insert(fileGroup);

            fileGroup.setName("安全");
            fileGroup.setParentId(1);
            dao.insert(fileGroup);
            fileGroup.setName("应急响应");
            fileGroup.setParentId(1);
            dao.insert(fileGroup);

            fileGroup.setName("代码审计");
            fileGroup.setParentId(2);
            dao.insert(fileGroup);
            fileGroup.setName("渗透测试");
            fileGroup.setParentId(2);
            dao.insert(fileGroup);
            fileGroup.setName("数据加密");
            fileGroup.setParentId(2);
            dao.insert(fileGroup);

            fileGroup.setName("SQL注入");
            fileGroup.setParentId(5);
            dao.insert(fileGroup);
            fileGroup.setName("XSS");
            fileGroup.setParentId(5);
            dao.insert(fileGroup);
            fileGroup.setName("文件操作");
            fileGroup.setParentId(5);
            dao.insert(fileGroup);
        }
    }

    public void destroy(NutConfig nc) {}

}
