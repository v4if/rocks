package net.wendal.nutzdemo.module;

import net.wendal.nutzdemo.bean.Logger;
import org.nutz.dao.Cnd;
import org.nutz.dao.Dao;
import org.nutz.dao.QueryResult;
import org.nutz.dao.pager.Pager;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.annotation.At;
import org.nutz.mvc.annotation.Ok;
import org.nutz.mvc.annotation.Param;

/**
 * Created by root on 1/19/17.
 */
@At("/logger")
@Ok("json:{locked:'password|salt'}")
@IocBean
public class LoggerModule {

    private static final Log log = Logs.get();
    @Inject
    private Dao dao;

    @At
    public Object query(@Param("..")Pager pager) {
        pager.setPageSize(8);

        QueryResult qr = new QueryResult();
        qr.setList(dao.query(Logger.class, Cnd.orderBy().desc("createTime"), pager));
        pager.setRecordCount(dao.count(Logger.class, null));
        qr.setPager(pager);
        return qr; //默认分页是第1页,每页20条
    }
}
