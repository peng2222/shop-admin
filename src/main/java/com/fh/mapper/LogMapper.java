package com.fh.mapper;

import com.fh.model.Log;
import com.fh.model.LogQuery;

import java.util.List;

public interface LogMapper {

    void addLog(Log log);

    long queryCountLog(LogQuery logQuery);

    List queryLog(LogQuery logQuery);
}
