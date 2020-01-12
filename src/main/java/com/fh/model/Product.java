package com.fh.model;

import java.math.BigDecimal;

public class Product {

    private Integer id;

    private String name; //商品名称

    private String title; //标题

    private Integer brandId; //品牌id

    private String brandName; //品牌名称

    private Integer status; //状态: 1代表上架 2代表下架

    private Integer isHot; //是否热销商品： 1代表是 2代表否

    private BigDecimal price; //商品均价，在前台门户系统商品列表也中显示使用

    private String filePath; //商品主图

    private String remark; //商品描述

    private Integer classifyId1; //商品一级分类id

    private Integer classifyId2; //商品二级分类id

    private Integer classifyId3; //商品三级分类id

    private String classifyName; //电子产品/手机/智能手机

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getIsHot() {
        return isHot;
    }

    public void setIsHot(Integer isHot) {
        this.isHot = isHot;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Integer getClassifyId1() {
        return classifyId1;
    }

    public void setClassifyId1(Integer classifyId1) {
        this.classifyId1 = classifyId1;
    }

    public Integer getClassifyId2() {
        return classifyId2;
    }

    public void setClassifyId2(Integer classifyId2) {
        this.classifyId2 = classifyId2;
    }

    public Integer getClassifyId3() {
        return classifyId3;
    }

    public void setClassifyId3(Integer classifyId3) {
        this.classifyId3 = classifyId3;
    }

    public String getClassifyName() {
        return classifyName;
    }

    public void setClassifyName(String classifyName) {
        this.classifyName = classifyName;
    }
}
