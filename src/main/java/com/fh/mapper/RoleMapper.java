package com.fh.mapper;

import com.fh.model.Role;
import com.fh.model.RoleQuery;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface RoleMapper {

    //统计总条数
    Long queryRoleCount(RoleQuery roleQuery);

    //查询当前页数据的方法
    List<Role> queryRoleList(RoleQuery roleQuery);

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

    void updateRoleStatus(@Param("id") Integer id, @Param("status") Integer status);

    List<Role> queryEnableRoleList();

    List<Role> queryAllRoleList();

    List<Role> queryRoleListNoPage(RoleQuery roleQuery);

    void batchAddRole(List<Role> roleList);
}
