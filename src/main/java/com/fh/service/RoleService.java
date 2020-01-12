package com.fh.service;

import com.fh.model.DataTableResult;
import com.fh.model.Role;
import com.fh.model.RoleQuery;

import java.util.List;

public interface RoleService {

    //分页条件查询角色信息
    DataTableResult queryRoleList(RoleQuery roleQuery);

    //新增角色
    void addRole(Role role);

    //删除角色
    void deleteRole(Integer id);

    //通过id获取单个角色信息
    Role getRoleById(Integer id);

    //修改角色
    void updateRole(Role role);

    //根据角色id删除角色信息
    void batchDeleteRole(List<Integer> ids);

    void updateRoleStatus(Integer id);

    List<Role> queryEnableRoleList();

    //查询所有角色集合用于导入导出测试
    List<Role> queryAllRoleList();

    List<Role> queryRoleListNoPage(RoleQuery roleQuery);

    void batchAddRole(List<Role> roleList);
}
