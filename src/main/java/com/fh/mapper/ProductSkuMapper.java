package com.fh.mapper;

import com.fh.model.ProductSku;

import java.util.List;

public interface ProductSkuMapper {

    void batchAddProductSku(List<ProductSku> productSkuList);

    void deleteSkuByProductId(Integer id);

    void batchDeleteSkuByProductId(List<Integer> idList);

    List<ProductSku> queryProductSkuListByProductId(Integer id);

    void deleteProductSkuByProductId(Integer id);
}
