package com.fh.service;

import com.fh.model.Permission;

import java.util.List;

public interface PermissionService {
    
    List<Permission> queryPermissionList();

    void addPermission(Permission permission);

    void deletePermission(List<Integer> ids);

    void updatePermission(Permission permission);

    List<Permission> queryPermissionListByUserId(Integer id);

    List<Permission> queryMenuPermissionListByUserId(Integer id);
}
