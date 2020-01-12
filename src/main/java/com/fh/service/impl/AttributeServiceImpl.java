package com.fh.service.impl;

import com.fh.mapper.AttributeMapper;
import com.fh.model.Attribute;
import com.fh.model.AttributeQuery;
import com.fh.model.AttributeValue;
import com.fh.model.DataTableResult;
import com.fh.service.AttributeService;
import com.fh.service.AttributeValueService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class AttributeServiceImpl implements AttributeService {

    @Autowired
    private AttributeMapper attributeMapper;

    @Autowired
    private AttributeValueService attributeValueService;

    @Override
    public DataTableResult queryAttributeList(AttributeQuery attributeQuery) {

        //1.查询总条数
        Long count = attributeMapper.queryAttributeCount(attributeQuery);

        //2.查询当前页数据
        List<Attribute> attributeList = attributeMapper.queryAttributeList(attributeQuery);

        DataTableResult dataTableResult = new DataTableResult(attributeQuery.getDraw(),count,count,attributeList);

        return dataTableResult;
    }

    @Override
    public void addAttribute(Attribute attribute) {
        attributeMapper.addAttribute(attribute);
        //判断属性可选项是否为空
        addAttributeValues(attribute);
    }

    @Override
    public Attribute getAttributeById(Integer id) {
        Attribute attribute = attributeMapper.getAttributeById(id);
        //查询该属性的可选项集合
        List<AttributeValue> attributeValueList = attributeValueService.queryAttributeValueListByAttributeId(id);
        //如果该属性有可选项
        if(attributeValueList != null && !attributeValueList.isEmpty()){
            //将该属性的可选项值以\n拼成一个字符串
            String inputList = "";
            for(AttributeValue attributeValue : attributeValueList){
                inputList += attributeValue.getValue() + "\n";
            }
            inputList = inputList.substring(0,inputList.length()-1);
            //核心代码
            attribute.setInputList(inputList);
        }
        return attribute;
    }

    @Override
    public void updateAttribute(Attribute attribute) {
        attributeMapper.updateAttribute(attribute);
        //删除这个属性之前的可选项
        attributeValueService.deleteAttributeValueByAttributeId(attribute.getId());
        //为属性添加新的可选项
        addAttributeValues(attribute);
    }

    private void addAttributeValues(Attribute attribute) {
        if (StringUtils.isNotBlank(attribute.getInputList())) {
            //通过\n分割可选项值
            String[] valueArr = attribute.getInputList().split("\n");
            List<AttributeValue> attributeValueList = new ArrayList<>();
            for (String value : valueArr) {
                AttributeValue attributeValue = new AttributeValue();
                attributeValue.setAttributeId(attribute.getId());
                attributeValue.setValue(value);
                attributeValueList.add(attributeValue);
            }
            //调用AttributeValueService的批量新增属性值方法
            attributeValueService.batchAddAttributeValue(attributeValueList);
        }
    }

    @Override
    public void deleteAttribute(Integer id) {
        attributeMapper.deleteAttribute(id);
        //删除该属性的可选项
        attributeValueService.deleteAttributeValueByAttributeId(id);
    }

    @Override
    public void batchDeleteAttribute(List<Integer> ids) {
        attributeMapper.batchDeleteAttribute(ids);
        attributeValueService.deleteAttributeValueByAttributeIds(ids);
    }

    @Override
    public List<Attribute> queryAttributeListByClassifyId(Integer classifyId) {
        return attributeMapper.queryAttributeListByClassifyId(classifyId);
    }
}
