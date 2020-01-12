package com.fh.mapper;

import com.fh.model.User;
import com.fh.model.UserQuery;

import java.util.List;

public interface UserMapper {

    //统计总条数
    Long queryUserCount(UserQuery userQuery);

    //查询当前页数据的方法
    List<User> queryUserList(UserQuery userQuery);

    //新增用户
    void addUser(User user);

    //删除用户
    void deleteUser(Integer id);

    //通过id获取单个用户信息
    User getUserById(Integer id);

    //修改用户
    void updateUser(User user);

    //根据用户id集合查询用户信息
    List<User> queryUserListByIds(List<Integer> ids);

    //根据用户id删除用户信息
    void batchDeleteUser(List<Integer> ids);

    //-----------------------------------------------用户登录模块---------------------------------------
    User getUserByName(String userName);

    void updateUserErrorCountAndErrorTime(User user);

    void updateUserLoginCountAndUserLoginTime(User user);

    //不带分页的条件查询  用于导出excel
    List<User> queryUserListNoPage(UserQuery userQuery);

    //批量导入用户
    void batchAddUser(List<User> userList);
}
