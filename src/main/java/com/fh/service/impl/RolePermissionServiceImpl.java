package com.fh.service.impl;

import com.fh.mapper.RolePermissionMapper;
import com.fh.model.RolePermission;
import com.fh.service.RolePermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RolePermissionServiceImpl implements RolePermissionService {

    @Autowired
    private RolePermissionMapper rolePermissionMapper;


    @Override
    public void addRolePermissions(List<RolePermission> rolePermissionList) {
        rolePermissionMapper.addRolePermissions(rolePermissionList);
    }

    @Override
    public List<RolePermission> queryRolePermissionListByRoleId(Integer id) {
        return rolePermissionMapper.queryRolePermissionListByRoleId(id);
    }

    @Override
    public void deleteRolePermissionByRoleId(Integer id) {
        rolePermissionMapper.deleteRolePermissionByRoleId(id);
    }
}
