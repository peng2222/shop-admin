package com.fh.model;

import java.util.List;

public class ProductInfo {

    private Product product;

    private List<ProductAttribute> productAttributeList;

    private List<ProductSku> productSkuList;

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public List<ProductAttribute> getProductAttributeList() {
        return productAttributeList;
    }

    public void setProductAttributeList(List<ProductAttribute> productAttributeList) {
        this.productAttributeList = productAttributeList;
    }

    public List<ProductSku> getProductSkuList() {
        return productSkuList;
    }

    public void setProductSkuList(List<ProductSku> productSkuList) {
        this.productSkuList = productSkuList;
    }
}
