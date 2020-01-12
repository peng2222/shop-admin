package com.fh.service.impl;

import com.fh.mapper.PermissionMapper;
import com.fh.model.Permission;
import com.fh.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class PermissionServiceImpl implements PermissionService {

    @Autowired
    private PermissionMapper permissionMapper;


    @Override
    public List<Permission> queryPermissionList() {
        return permissionMapper.queryPermissionList();
    }

    @Override
    public void addPermission(Permission permission) {
        permission.setCreateDate(new Date());
        permissionMapper.addPermission(permission);
    }

    @Override
    public void deletePermission(List<Integer> ids) {
        permissionMapper.deletePermission(ids);
    }

    @Override
    public void updatePermission(Permission permission) {
        permissionMapper.updatePermission(permission);
    }

    @Override
    public List<Permission> queryPermissionListByUserId(Integer id) {
        return permissionMapper.queryPermissionListByUserId(id);
    }

    @Override
    public List<Permission> queryMenuPermissionListByUserId(Integer id) {
        return permissionMapper.queryMenuPermissionListByUserId(id);
    }
}
