package com.fh.mapper;

import com.fh.model.AttributeValue;

import java.util.List;

public interface AttributeValueMapper {

    void batchAddAttributeValue(List<AttributeValue> attributeValueList);

    List<AttributeValue> queryAttributeValueListByAttributeId(Integer id);

    void deleteAttributeValueByAttributeId(Integer id);

    void deleteAttributeValueByAttributeIds(List<Integer> ids);

    AttributeValue getAttributeValueByAttributeIdAndValue(AttributeValue attributeValue);

    void addAttributeValue(AttributeValue attributeValue);

}
