package com.fh.controller;

import com.fh.model.City;
import com.fh.service.CityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("CityController")
public class CityController {

    @Autowired
    private CityService cityService;

    //跳转转到城市展示页面
    @RequestMapping("toCityList")
    public String toCityList(){
        return "city/city-tree";
    }

    //查询所有城市信息
    @RequestMapping("queryCityList")
    @ResponseBody
    public Map<String,Object> queryCityList(){
        Map<String,Object> result = new HashMap<>();
        try {
            List<City> cityList = cityService.queryCityList();
            result.put("data",cityList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //新增城市
    @RequestMapping("addCity")
    @ResponseBody
    public Map<String,Object> addCity(City city){
        Map<String,Object> result = new HashMap<>();
        try {
            cityService.addCity(city);
            //注意:这块需要将新增的这个城市返回回去
            result.put("data",city);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //删除城市
    @RequestMapping("deleteCity")
    @ResponseBody
    public Map<String,Object> deleteCity(@RequestParam("ids[]")List<Integer> ids){
        Map<String,Object> result = new HashMap<>();
        try {
            cityService.deleteCity(ids);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //修改城市
    @RequestMapping("updateCity")
    @ResponseBody
    public Map<String,Object> updateCity(City city){
        Map<String,Object> result = new HashMap<>();
        try {
            cityService.updateCity(city);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //根据pid查询所有城市信息
    @RequestMapping("queryCityListByPid")
    @ResponseBody
    public Map<String,Object> queryCityListByPid(Integer pid){
        Map<String,Object> result = new HashMap<>();
        try {
            List<City> cityList = cityService.queryCityListByPid(pid);
            result.put("data",cityList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }
}
