package com.fh.service.impl;

import com.fh.mapper.LogMapper;
import com.fh.model.DataTableResult;
import com.fh.model.Log;
import com.fh.model.LogQuery;
import com.fh.service.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LogServiceImpl implements LogService {
    @Autowired
    private LogMapper logMapper;

    public void addLog(Log log) {
        logMapper.addLog(log);
    }


    @Override
    public DataTableResult queryLogList(LogQuery logQuery) {
        //1.查询总数
        Long count = logMapper.queryCountLog(logQuery);

        //2.查询当前页数据
        List<Log> LogList =  logMapper.queryLog(logQuery);

        DataTableResult dataTableResult = new DataTableResult(logQuery.getDraw(),count,count,LogList);

        return dataTableResult;
    }
}
