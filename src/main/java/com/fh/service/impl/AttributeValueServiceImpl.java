package com.fh.service.impl;

import com.fh.mapper.AttributeValueMapper;
import com.fh.model.AttributeValue;
import com.fh.service.AttributeValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AttributeValueServiceImpl implements AttributeValueService {

    @Autowired
    private AttributeValueMapper attributeValueMapper;

    @Override
    public void batchAddAttributeValue(List<AttributeValue> attributeValueList) {
        attributeValueMapper.batchAddAttributeValue(attributeValueList);
    }


    @Override
    public List<AttributeValue> queryAttributeValueListByAttributeId(Integer id) {
        return attributeValueMapper.queryAttributeValueListByAttributeId(id);
    }

    @Override
    public void deleteAttributeValueByAttributeId(Integer id) {
        attributeValueMapper.deleteAttributeValueByAttributeId(id);
    }

    @Override
    public void deleteAttributeValueByAttributeIds(List<Integer> ids) {
        attributeValueMapper.deleteAttributeValueByAttributeIds(ids);
    }

    @Override
    public boolean attributeValueIsExisted(AttributeValue attributeValue) {
        AttributeValue aaa = attributeValueMapper.getAttributeValueByAttributeIdAndValue(attributeValue);
        return aaa == null;
    }

    @Override
    public void addAttributeValue(AttributeValue attributeValue) {
        attributeValueMapper.addAttributeValue(attributeValue);
    }
}
