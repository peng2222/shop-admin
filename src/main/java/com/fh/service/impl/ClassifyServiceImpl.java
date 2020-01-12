package com.fh.service.impl;

import com.fh.mapper.ClassifyMapper;
import com.fh.model.Classify;
import com.fh.service.ClassifyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class ClassifyServiceImpl implements ClassifyService {

    @Autowired
    private ClassifyMapper classifyMapper;

    @Override
    public List<Classify> queryClassifyList() {
        return classifyMapper.queryClassifyList();
    }

    @Override
    public void addClassify(Classify classify) {
        classify.setCreateDate(new Date());
        classifyMapper.addClassify(classify);
    }

    @Override
    public void deleteClassify(List<Integer> ids) {
        classifyMapper.deleteClassify(ids);
    }

    @Override
    public void updateClassify(Classify classify) {
        classify.setUpdateDate(new Date());
        classifyMapper.updateClassify(classify);
    }

    @Override
    public List<Classify> queryClassifyListByPid(Integer pid) {
        return classifyMapper.queryClassifyListByPid(pid);
    }
}
