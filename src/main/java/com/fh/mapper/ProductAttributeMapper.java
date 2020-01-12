package com.fh.mapper;

import com.fh.model.ProductAttribute;

import java.util.List;

public interface ProductAttributeMapper {

    void batchAddProductAttribute(List<ProductAttribute> productAttributeList);

    void deleteAttributeByProductId(Integer id);

    void batchDeleteAttributeByProductId(List<Integer> idList);

    List<ProductAttribute> queryProductAttributeListByProductId(Integer id);

    void deleteProductAttributeByProductId(Integer id);
}
