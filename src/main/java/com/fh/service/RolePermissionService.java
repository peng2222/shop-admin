package com.fh.service;

import com.fh.model.RolePermission;

import java.util.List;

public interface RolePermissionService {

    void addRolePermissions(List<RolePermission> rolePermissionList);

    List<RolePermission> queryRolePermissionListByRoleId(Integer id);

    void deleteRolePermissionByRoleId(Integer id);
}
