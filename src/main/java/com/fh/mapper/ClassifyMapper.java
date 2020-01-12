package com.fh.mapper;

import com.fh.model.Classify;

import java.util.List;

public interface ClassifyMapper {
    
    List<Classify> queryClassifyList();

    void addClassify(Classify classify);

    void deleteClassify(List<Integer> ids);

    void updateClassify(Classify classify);

    List<Classify> queryClassifyListByPid(Integer pid);
}
