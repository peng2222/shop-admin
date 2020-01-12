package com.fh.service.impl;

import com.fh.mapper.ProductSkuMapper;
import com.fh.model.ProductSku;
import com.fh.service.ProductSkuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductSkuServiceImpl implements ProductSkuService {

    @Autowired
    private ProductSkuMapper productSkuMapper;

    @Override
    public void batchAddProductSku(List<ProductSku> productSkuList) {
        productSkuMapper.batchAddProductSku(productSkuList);
    }

    @Override
    public void deleteSkuByProductId(Integer id) {
        productSkuMapper.deleteSkuByProductId(id);
    }

    @Override
    public void batchDeleteSkuByProductId(List<Integer> idList) {
        productSkuMapper.batchDeleteSkuByProductId(idList);
    }

    @Override
    public List<ProductSku> queryProductSkuListByProductId(Integer id) {
        return productSkuMapper.queryProductSkuListByProductId(id);
    }

    @Override
    public void deleteProductSkuByProductId(Integer id) {
        productSkuMapper.deleteProductSkuByProductId(id);
    }
}
