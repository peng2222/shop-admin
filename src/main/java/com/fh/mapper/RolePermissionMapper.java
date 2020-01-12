package com.fh.mapper;

import com.fh.model.RolePermission;

import java.util.List;

public interface RolePermissionMapper {

    void addRolePermissions(List<RolePermission> rolePermissionList);

    List<RolePermission> queryRolePermissionListByRoleId(Integer id);

    void deleteRolePermissionByRoleId(Integer id);
}
