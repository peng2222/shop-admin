package com.fh.model;

public class Attribute {

    private Integer id;

    private String name;//属性名

    private Integer type;//属性类型: 1代表SPU属性(关键属性)  2代表SKU属性(销售属性)

    private Integer selectType;//属性选择类型: 1代表输入框 2代表单选按钮 3代表复选框 4代表下拉框

    private Integer inputType;//属性值录入方式: 1代表手动输入 2代表从已有的选项中去选择属性值

    private Integer addable;//是否允许新增属性值: 1是 2否

    private Integer classifyId;//商品分类id(注意:这里存储的是商品分类叶子节点的id)

    private String inputList;

    //用于存放该商品属性已关联的商品属性值id串
    private String valueIdList;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getSelectType() {
        return selectType;
    }

    public void setSelectType(Integer selectType) {
        this.selectType = selectType;
    }

    public Integer getInputType() {
        return inputType;
    }

    public void setInputType(Integer inputType) {
        this.inputType = inputType;
    }

    public Integer getAddable() {
        return addable;
    }

    public void setAddable(Integer addable) {
        this.addable = addable;
    }

    public Integer getClassifyId() {
        return classifyId;
    }

    public void setClassifyId(Integer classifyId) {
        this.classifyId = classifyId;
    }

    public String getInputList() {
        return inputList;
    }

    public void setInputList(String inputList) {
        this.inputList = inputList;
    }

    public String getValueIdList() {
        return valueIdList;
    }

    public void setValueIdList(String valueIdList) {
        this.valueIdList = valueIdList;
    }
}
