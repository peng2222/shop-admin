package com.fh.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class UserQuery extends DataTablePageBean{
    private String userName;//用户姓名

    private String realName;//真实姓名

    private String phoneNumber;//手机号

    private String email;//邮箱

    private Integer sex;//性别
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date minBirthday;//最早生日
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date maxBirthday;//最晚生日
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date minCreateDate;//最早创建日期
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date maxCreateDate;//最晚创建日期
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date minUpdateDate;//最早修改日期
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date maxUpdateDate;//最晚修改日期

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public Date getMinBirthday() {
        return minBirthday;
    }

    public void setMinBirthday(Date minBirthday) {
        this.minBirthday = minBirthday;
    }

    public Date getMaxBirthday() {
        return maxBirthday;
    }

    public void setMaxBirthday(Date maxBirthday) {
        this.maxBirthday = maxBirthday;
    }

    public Date getMinCreateDate() {
        return minCreateDate;
    }

    public void setMinCreateDate(Date minCreateDate) {
        this.minCreateDate = minCreateDate;
    }

    public Date getMaxCreateDate() {
        return maxCreateDate;
    }

    public void setMaxCreateDate(Date maxCreateDate) {
        this.maxCreateDate = maxCreateDate;
    }

    public Date getMinUpdateDate() {
        return minUpdateDate;
    }

    public void setMinUpdateDate(Date minUpdateDate) {
        this.minUpdateDate = minUpdateDate;
    }

    public Date getMaxUpdateDate() {
        return maxUpdateDate;
    }

    public void setMaxUpdateDate(Date maxUpdateDate) {
        this.maxUpdateDate = maxUpdateDate;
    }
}
