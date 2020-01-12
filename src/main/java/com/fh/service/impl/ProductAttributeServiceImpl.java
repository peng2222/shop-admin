package com.fh.service.impl;

import com.fh.mapper.ProductAttributeMapper;
import com.fh.model.ProductAttribute;
import com.fh.service.ProductAttributeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductAttributeServiceImpl implements ProductAttributeService {

    @Autowired
    private ProductAttributeMapper productAttributeMapper;

    @Override
    public void batchAddProductAttribute(List<ProductAttribute> productAttributeList) {
        productAttributeMapper.batchAddProductAttribute(productAttributeList);
    }

    @Override
    public void deleteAttributeByProductId(Integer id) {
        productAttributeMapper.deleteAttributeByProductId(id);
    }

    @Override
    public void batchDeleteAttributeByProductId(List<Integer> idList) {
        productAttributeMapper.batchDeleteAttributeByProductId(idList);
    }

    @Override
    public List<ProductAttribute> queryProductAttributeListByProductId(Integer id) {
        return productAttributeMapper.queryProductAttributeListByProductId(id);
    }

    @Override
    public void deleteProductAttributeByProductId(Integer id) {
        productAttributeMapper.deleteProductAttributeByProductId(id);
    }
}
