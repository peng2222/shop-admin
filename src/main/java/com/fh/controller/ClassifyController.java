package com.fh.controller;

import com.fh.model.Classify;
import com.fh.service.ClassifyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("ClassifyController")
public class ClassifyController {

    @Autowired
    private ClassifyService classifyService;

    //跳转转到分类展示页面
    @RequestMapping("toClassifyList")
    public String toClassifyList(){
        return "classify/classify-tree";
    }

    //查询所有分类信息
    @RequestMapping("queryClassifyList")
    @ResponseBody
    public Map<String,Object> queryClassifyList(){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Classify> classifyList = classifyService.queryClassifyList();
            result.put("data",classifyList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //新增分类
    @RequestMapping("addClassify")
    @ResponseBody
    public Map<String,Object> addClassify(Classify classify){
        Map<String,Object> result = new HashMap<>();
        try {
            classifyService.addClassify(classify);
            //注意:这块需要将新增的这个分类返回回去
            result.put("data",classify);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //删除分类
    @RequestMapping("deleteClassify")
    @ResponseBody
    public Map<String,Object> deleteClassify(@RequestParam("ids[]")List<Integer> ids){
        Map<String,Object> result = new HashMap<>();
        try {
            classifyService.deleteClassify(ids);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //修改分类
    @RequestMapping("updateClassify")
    @ResponseBody
    public Map<String,Object> updateClassify(Classify classify){
        Map<String,Object> result = new HashMap<>();
        try {
            classifyService.updateClassify(classify);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //根据pid查询所有分类信息
    @RequestMapping("queryClassifyListByPid")
    @ResponseBody
    public Map<String,Object> queryClassifyListByPid(Integer pid){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Classify> classifyList = classifyService.queryClassifyListByPid(pid);
            result.put("data",classifyList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }
}
