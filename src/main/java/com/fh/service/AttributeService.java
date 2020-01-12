package com.fh.service;

import com.fh.model.Attribute;
import com.fh.model.AttributeQuery;
import com.fh.model.DataTableResult;

import java.util.List;

public interface AttributeService {

    DataTableResult queryAttributeList(AttributeQuery attributeQuery);

    void addAttribute(Attribute attribute);

    Attribute getAttributeById(Integer id);

    void updateAttribute(Attribute attribute);

    void deleteAttribute(Integer id);

    void batchDeleteAttribute(List<Integer> ids);

    List<Attribute> queryAttributeListByClassifyId(Integer classifyId);

}
