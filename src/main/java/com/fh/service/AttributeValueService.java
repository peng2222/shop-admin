package com.fh.service;

import com.fh.model.AttributeValue;

import java.util.List;

public interface AttributeValueService {

    void batchAddAttributeValue(List<AttributeValue> attributeValueList);

    List<AttributeValue> queryAttributeValueListByAttributeId(Integer id);

    void deleteAttributeValueByAttributeId(Integer id);

    void deleteAttributeValueByAttributeIds(List<Integer> ids);

    boolean attributeValueIsExisted(AttributeValue attributeValue);

    void addAttributeValue(AttributeValue attributeValue);

}
