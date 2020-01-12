package com.fh.service;

import com.fh.model.ProductSku;

import java.util.List;

public interface ProductSkuService {

    void batchAddProductSku(List<ProductSku> productSkuList);

    void deleteSkuByProductId(Integer id);

    void batchDeleteSkuByProductId(List<Integer> idList);

    List<ProductSku> queryProductSkuListByProductId(Integer id);

    void deleteProductSkuByProductId(Integer id);
}
