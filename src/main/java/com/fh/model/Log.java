package com.fh.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class Log {
    private Integer id;//ID

    private String username;//操作人

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;//操作时间

    private int status;//状态

    private String content;//内容

    private String parameter;//参数

    private String action;//方法


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getParameter() {
        return parameter;
    }

    public void setParameter(String parameter) {
        this.parameter = parameter;
    }


    public Log() {
    }

    public Log(Integer id, String username, Date createTime, int status, String content, String parameter, String action, Date minDate, Date maxDate) {
        this.id = id;
        this.username = username;
        this.createTime = createTime;
        this.status = status;
        this.content = content;
        this.parameter = parameter;
        this.action = action;

    }
}
