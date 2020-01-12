package com.fh.controller;

import com.fh.model.DataTableResult;
import com.fh.model.LogQuery;
import com.fh.service.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("log")
public class LogController {


    @Autowired
    private LogService logService;


    //跳转到日志展示页面
    @RequestMapping("toLogList")
    public String toUserList(){
        return "log/log-list";
    }


    @RequestMapping("queryLogList")
    @ResponseBody
    public DataTableResult queryLog(LogQuery logQuery){

        DataTableResult dataTableResult = logService.queryLogList(logQuery);

        return dataTableResult;

    }
}
