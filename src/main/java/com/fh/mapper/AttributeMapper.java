package com.fh.mapper;

import com.fh.model.Attribute;
import com.fh.model.AttributeQuery;

import java.util.List;

public interface AttributeMapper {

    Long queryAttributeCount(AttributeQuery attributeQuery);

    List<Attribute> queryAttributeList(AttributeQuery attributeQuery);

    void addAttribute(Attribute attribute);

    Attribute getAttributeById(Integer id);

    void updateAttribute(Attribute attribute);

    void deleteAttribute(Integer id);

    void batchDeleteAttribute(List<Integer> ids);

    List<Attribute> queryAttributeListByClassifyId(Integer classifyId);
}
