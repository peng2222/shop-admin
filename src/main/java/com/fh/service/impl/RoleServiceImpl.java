package com.fh.service.impl;

import com.fh.mapper.RoleMapper;
import com.fh.model.DataTableResult;
import com.fh.model.Role;
import com.fh.model.RolePermission;
import com.fh.model.RoleQuery;
import com.fh.service.RolePermissionService;
import com.fh.service.RoleService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private RolePermissionService rolePermissionService;

    @Override
    public DataTableResult queryRoleList(RoleQuery roleQuery) {

        //1.查询总数
        Long count = roleMapper.queryRoleCount(roleQuery);

        //2.查询当前页数据
        List<Role> roleList =  roleMapper.queryRoleList(roleQuery);

        DataTableResult dataTableResult = new DataTableResult(roleQuery.getDraw(),count,count,roleList);
        return dataTableResult;
    }

    @Override
    public void addRole(Role role) {
        role.setCreateDate(new Date());
        roleMapper.addRole(role);
        //为角色关联权限
        addRolePermissions(role);
    }

    @Override
    public void updateRole(Role role) {
        role.setUpdateDate(new Date());
        roleMapper.updateRole(role);
        //删除该角色之前关联的权限
        rolePermissionService.deleteRolePermissionByRoleId(role.getId());
        addRolePermissions(role);
    }



    @Override
    public void deleteRole(Integer id) {
        roleMapper.deleteRole(id);
    }


    @Override
    public void batchDeleteRole(List<Integer> idList) {
        roleMapper.batchDeleteRole(idList);
    }


    @Override
    public void updateRoleStatus(Integer id) {
        Role role = roleMapper.getRoleById(id);
        roleMapper.updateRoleStatus(id,role.getStatus()==1?2:1);
    }

    @Override
    public List<Role> queryEnableRoleList() {
        return roleMapper.queryEnableRoleList();
    }

    @Override
    public List<Role> queryAllRoleList() {
        return roleMapper.queryAllRoleList();
    }

    @Override
    public List<Role> queryRoleListNoPage(RoleQuery roleQuery) {
        return roleMapper.queryRoleListNoPage(roleQuery);
    }

    @Override
    public void batchAddRole(List<Role> roleList) {
        roleMapper.batchAddRole(roleList);
    }

    @Override
    public Role getRoleById(Integer id) {
        Role role = roleMapper.getRoleById(id);
        //通过角色id查询角色关联的权限集合
        List<RolePermission> rolePermissionList = rolePermissionService.queryRolePermissionListByRoleId(id);
        if(rolePermissionList != null && !rolePermissionList.isEmpty()){
            String permissionIds = "";
            for(RolePermission rolePermission : rolePermissionList){
                permissionIds += rolePermission.getPermissionId() + ",";
            }
            permissionIds = permissionIds.substring(0,permissionIds.length()-1);
            role.setPermissionIds(permissionIds);
        }
        return role;
    }

    private void addRolePermissions(Role role) {
        //为角色关联新的权限
        if (StringUtils.isNotBlank(role.getPermissionIds())) {
            List<RolePermission> rolePermissionList = new ArrayList<>();
            String[] permissionIdArr = role.getPermissionIds().split(",");
            for (String permissionId : permissionIdArr) {
                RolePermission rolePermission = new RolePermission();
                rolePermission.setRoleId(role.getId());
                rolePermission.setPermissionId(Integer.valueOf(permissionId));
                rolePermissionList.add(rolePermission);
            }
            rolePermissionService.addRolePermissions(rolePermissionList);
        }
    }
}
