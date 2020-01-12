package com.fh.controller;


import com.fh.model.Attribute;
import com.fh.model.AttributeQuery;
import com.fh.model.AttributeValue;
import com.fh.model.DataTableResult;
import com.fh.service.AttributeService;
import com.fh.service.AttributeValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("AttributeController")
public class AttributeController {

    @Autowired
    private AttributeService attributeService;

    @Autowired
    private AttributeValueService attributeValueService;

    //跳转到属性展示页面
    @RequestMapping("toAttributeList")
    public String toAttributeList(){
        return "attribute/attribute-list";
    }


        //分页条件查询属性信息
        @RequestMapping("queryAttributeList")
        @ResponseBody
        public DataTableResult queryAttributeList(AttributeQuery attributeQuery){
            DataTableResult dataTableResult = attributeService.queryAttributeList(attributeQuery);
            return dataTableResult;
        }


    //新增属性
    @RequestMapping("addAttribute")
    @ResponseBody
    public Map<String,Object> addAttribute(Attribute attribute){
        Map<String,Object> result = new HashMap<>();
        try {
            attributeService.addAttribute(attribute);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //通过id获取单个属性信息
    @RequestMapping("getAttributeById")
    @ResponseBody
    public Map<String,Object> getAttributeById(Integer id){
        Map<String,Object> result = new HashMap<>();
        try {
            Attribute attribute = attributeService.getAttributeById(id);
            result.put("data",attribute);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //修改属性
    @RequestMapping("updateAttribute")
    @ResponseBody
    public Map<String,Object> updateAttribute(Attribute attribute){
        Map<String,Object> result = new HashMap<>();
        try {
            attributeService.updateAttribute(attribute);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //删除属性
    @RequestMapping("deleteAttribute")
    @ResponseBody
    public Map<String,Object> deleteAttribute(Integer id){
        Map<String,Object> result = new HashMap<>();
        try {
            attributeService.deleteAttribute(id);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //批量删除属性
    @RequestMapping("batchDeleteAttribute")
    @ResponseBody
    public Map<String,Object> batchDeleteAttribute(@RequestParam("ids[]") List<Integer> ids){
        Map<String,Object> result = new HashMap<>();
        try {
            attributeService.batchDeleteAttribute(ids);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //通过分类id查询该分类下的所有属性集合
    @RequestMapping("queryAttributeListByClassifyId")
    @ResponseBody
    public Map<String,Object> queryAttributeListByClassifyId(Integer classifyId){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Attribute> attributeList = attributeService.queryAttributeListByClassifyId(classifyId);
            result.put("data",attributeList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //判断属性值是否存在
    @RequestMapping("attributeValueIsExisted")
    @ResponseBody
    public Map<String,Object> attributeValueIsExisted(AttributeValue attributeValue){
        Map<String,Object> result = new HashMap<>();
        try {
            boolean flag = attributeValueService.attributeValueIsExisted(attributeValue);
            result.put("data",flag);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //新增属性值
    @RequestMapping("addAttributeValue")
    @ResponseBody
    public Map<String,Object> addAttributeValue(AttributeValue attributeValue){
        Map<String,Object> result = new HashMap<>();
        try {
            attributeValueService.addAttributeValue(attributeValue);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    
}
