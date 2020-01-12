package com.fh.service;

import com.fh.model.DataTableResult;
import com.fh.model.Log;
import com.fh.model.LogQuery;

import java.util.List;

public interface LogService {

    void addLog(Log log);

    DataTableResult queryLogList(LogQuery logQuery);
}
