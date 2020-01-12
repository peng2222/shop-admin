package com.fh.mapper;

import com.fh.model.Permission;

import java.util.List;

public interface PermissionMapper {

    //查询所有权限
    List<Permission> queryPermissionList();

    //新增权限
    void addPermission(Permission permission);

    //删除权限
    void deletePermission(List<Integer> ids);

    //修改权限
    void updatePermission(Permission permission);

    //查询当前登录用户所拥有的权限集合
    List<Permission> queryPermissionListByUserId(Integer id);

    //查询当前登录用户所用的菜单权限集合
    List<Permission> queryMenuPermissionListByUserId(Integer id);
}
