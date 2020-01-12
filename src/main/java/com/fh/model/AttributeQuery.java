package com.fh.model;

public class AttributeQuery extends DataTablePageBean{

    private Integer classifyId;//商品分类ID

    private String name;//属性名模糊查询

    private Integer type;//属性类型: 1代表SPU属性(关键属性)  2代表SKU属性(销售属性)

    private Integer selectType;//属性选择类型: 1代表输入框 2代表单选按钮 3代表复选框 4代表下拉框

    private Integer inputType;//属性值录入方式: 1代表手动输入 2代表从已有的选项中去选择属性值

    private Integer addable;//是否允许新增属性值: 1是 2否

    public Integer getClassifyId() {
        return classifyId;
    }

    public void setClassifyId(Integer classifyId) {
        this.classifyId = classifyId;
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
}
