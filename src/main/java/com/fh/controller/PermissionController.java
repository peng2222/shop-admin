package com.fh.controller;

import com.fh.model.Permission;
import com.fh.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("PermissionController")
public class PermissionController {

    @Autowired
    private PermissionService permissionService;

    //跳转到权限展示页面
    @RequestMapping("toPermissionList")
    public String toPermissionList(){
        return "permission/permission-tree";
    }

    //查询当前用户所拥有的菜单权限集合
    @RequestMapping("queryMenuPermissionList")
    @ResponseBody
    public Map<String,Object> queryMenuPermissionList(HttpSession session){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Permission> menuPermissionList = (List<Permission>)session.getAttribute("menuPermissionList");
            result.put("data",menuPermissionList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //查询所有权限信息
    @RequestMapping("queryPermissionList")
    @ResponseBody
    public Map<String,Object> queryPermissionList(){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Permission> permissionList = permissionService.queryPermissionList();
            result.put("data",permissionList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //新增权限
    @RequestMapping("addPermission")
    @ResponseBody
    public Map<String,Object> addPermission(Permission permission){
        Map<String,Object> result = new HashMap<>();
        try {
            permissionService.addPermission(permission);
            //注意:这块需要将新增的这个权限的id返回回去
            result.put("data",permission);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //删除权限
    @RequestMapping("deletePermission")
    @ResponseBody
    public Map<String,Object> deletePermission(@RequestParam("ids[]")List<Integer> ids){
        Map<String,Object> result = new HashMap<>();
        try {
            permissionService.deletePermission(ids);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //修改权限
    @RequestMapping("updatePermission")
    @ResponseBody
    public Map<String,Object> updatePermission(Permission permission){
        Map<String,Object> result = new HashMap<>();
        try {
            permissionService.updatePermission(permission);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

}
