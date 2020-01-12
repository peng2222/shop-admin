package com.fh.mapper;

import com.fh.model.UserRole;

import java.util.List;

public interface UserRoleMapper {
    
    List<UserRole> queryUserRoleListByUserId(Integer id);

    void addUserRoles(List<UserRole> userRoleList);

    void deleteUserRoleByUserId(Integer id);

}
