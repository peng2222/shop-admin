package com.fh.service;

import com.fh.model.Classify;

import java.util.List;

public interface ClassifyService {

    //查询所有分类信息
    List<Classify> queryClassifyList();

    //新增分类
    void addClassify(Classify classify);

    //删除分类
    void deleteClassify(List<Integer> ids);

    //修改分类
    void updateClassify(Classify classify);

    List<Classify> queryClassifyListByPid(Integer pid);
}
