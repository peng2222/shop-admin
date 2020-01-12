package com.fh.service;

import com.fh.model.DataTableResult;
import com.fh.model.User;
import com.fh.model.UserQuery;

import java.util.List;

public interface UserService {

    DataTableResult queryUserList(UserQuery userQuery);

    void addUser(User user);

    void updateUser(User user);

    User getUserById(Integer id);

    void deleteUser(Integer id);

    List<User> queryUserListByIds(List<Integer> idList);

    void batchDeleteUser(List<Integer> idList);

    //-----------------------------------------------用户登录模块---------------------------------------
    User getUserByName(String userName);

    void updateUserErrorCountAndErrorTime(User user);

    void updateUserLoginCountAndUserLoginTime(User user);

    //不带分页的条件查询  用于导出excel
    List<User> queryUserListNoPage(UserQuery userQuery);

    //批量导入用户
    void batchAddUser(List<User> userList);
}
