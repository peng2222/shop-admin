package com.fh.service;

import com.fh.model.UserRole;

import java.util.List;

public interface UserRoleService {

    void addUserRoles(List<UserRole> userRoleList);

    List<UserRole> queryUserRoleListByUserId(Integer id);

    void deleteUserRoleByUserId(Integer id);
}
